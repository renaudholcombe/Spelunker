//
//  SplunkProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkProvider.h"
#import "AlertHandler.h"
#import "SplunkReturnTypes.h"

@implementation SplunkProvider

const NSInteger JOBSTATUSTRIES = 10;

#pragma mark initializers

+(id) sharedProvider
{
    static SplunkProvider *splunkProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        splunkProvider = [[SplunkProvider alloc] init];
    });

    DDLogInfo(@"SplunkProvider initialized");

    return splunkProvider;
}

-(id) init
{
    self = [super init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSession:) name:@"Settings updated" object:nil];

    jobCheckQueue = [NSOperationQueue new];

    return self;
}

-(void) refreshSession: (NSNotification *) notification
{
    settings = notification.object;

    sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *authString = [NSString stringWithFormat:@"%@:%@", settings.splunkUsername, settings.splunkPassword];

    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];

    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization": authHeader
                                                   };
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

}

#pragma mark test methods

-(void) testConnection:(Settings *)testSettings
{
    //try to get a login token
    NSURL *url = [self createSplunkURL:settings withEndpoint:@"/services/search/jobs/" withOutputType:nil];

    NSURLSessionConfiguration *testConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *authString = [NSString stringWithFormat:@"%@:%@", settings.splunkUsername, settings.splunkPassword];

    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];

    testConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization": authHeader
                                                   };
    NSURLSession *testSession = [NSURLSession sessionWithConfiguration:testConfiguration];

    NSURLSessionDataTask *dataTask = [testSession dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error != nil){
            [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error connecting to Splunk!" withError:error]];
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response ;
        if(httpResponse.statusCode == 401 || httpResponse.statusCode == 403)
        {
            [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Splunk authentication failed!" withError:nil]];

            return;
        }

        if(httpResponse.statusCode == 200)
            [AlertHandler showAlert:@"Splunk connection succeeded!"];

    }];

    [dataTask resume];
}

#pragma mark search methods

-(void) searchSplunk:(Alert *) alert isTest: (BOOL) isTest
{
    //create job
    NSURL *createUrl = [self createSplunkURL: settings withEndpoint:@"/services/search/jobs/" withOutputType:@"json"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:createUrl];
    request.HTTPMethod = @"POST";
    NSString *searchString = [NSString stringWithFormat:@"search=%@", alert.searchString];
    request.HTTPBody = [searchString dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){

        if(error != nil)
        {
            DDLogError(@"Error executing splunk job creation");
            DDLogDebug(@"%@", error);
            return;

        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode != 201)
        {
            NSString *responseMessage;
            switch(httpResponse.statusCode)
            {
                case 401:
                case 403:
                    responseMessage = @"Splunk job creation API call returned unauthorized";
                    if(isTest)
                        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:responseMessage withError:nil]];
                    DDLogError(@"%@",responseMessage);
                    break;
                case 400:
                    responseMessage = @"Splunk job creation API returned \"Bad Request\". Confirm your search string";

                    if(isTest)
                        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:responseMessage withError:nil]];

                    DDLogError(@"%@", responseMessage);
                    return;
                    break;
                default:
                    responseMessage = [NSString stringWithFormat:@"Splunk job creation API call returned unexpected status code: %ldl", (long)httpResponse.statusCode];
                    DDLogWarn(@"%@", responseMessage);
                    break;
            }

        }
        if(data == nil)
        {
            if(isTest)
                [AlertHandler showAlert:@"Received empty result from splunk"];

            DDLogWarn(@"Received empty data from splunk");
            return;
        }
        NSString *rawResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        DDLogDebug(@"Splunk job creation result: %@", rawResult);

        error = nil;

        id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if(error) {
            DDLogError(@"Error parsing splunk job creation result");
            DDLogDebug(@"%@", error);

            if(isTest)
            {
//                        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error parsing splunk job creation result" withError:error]];
            }
        }

        if(![object isKindOfClass:[NSDictionary class]])
        {
            DDLogError(@"Splunk job creation result not in expected format");
            if(isTest)
            {
                [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Splunk result not in expected format" withError:nil] ];
            }
        }

        if(isTest)
        {
            //put back later
            //[AlertHandler showAlert:@"Splunk query valid"];
            //return;
        }

        NSDictionary *result = object;
        NSDecimalNumber *jobId = [result objectForKey:@"sid"];

        __block SplunkJob *job = [[SplunkJob alloc] initWithAlert:alert withJobId:jobId];
        DDLogInfo(@"Splunk job created with sId: %@ for alert \"%@\"", job.jobId, alert.alertName);

        //start checking the status
        NSBlockOperation *statusCheck = [NSBlockOperation blockOperationWithBlock:^{
            sleep(1); //kludgy, but simpler than the alternative GCD gynastics
            [self checkSplunkJobStatus:job triesLeft:JOBSTATUSTRIES];
        }];

        [jobCheckQueue addOperation:statusCheck];
    }];

    [dataTask resume];
}

-(void) checkSplunkJobStatus: (SplunkJob *) job triesLeft: (NSInteger) tries
{
    if(--tries < 0)
    {
        DDLogWarn(@"%@", [NSString stringWithFormat:@"Alert \"%@\" ran out of tries checking job status", job.alert.alertName]);
        return;
    }

    DDLogInfo(@"Beginning status check %ld for alert \"%@\"", (long)(JOBSTATUSTRIES - tries), job.alert.alertName);

    NSURL *createUrl = [self createSplunkURL: settings withEndpoint:[NSString stringWithFormat:@"/services/search/jobs/%@/", job.jobId] withOutputType:@"json"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:createUrl];
    request.HTTPMethod = @"GET";

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error)
        {
            DDLogError(@"Error checking job status for alert \"%@\"", job.alert.alertName);
            //not returning for now to get some retry logic in place
        } else
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if(httpResponse.statusCode != 200)
            {
                NSString *responseMessage;
                switch(httpResponse.statusCode)
                {
                    case 401:
                    case 403:
                        responseMessage = @"Splunk job status check API call returned unauthorized";
                        DDLogError(@"%@",responseMessage);
                        return;
                        break;
                    case 400:
                        responseMessage = @"Splunk job status check API returned \"Bad Request\"";
                        DDLogError(@"%@", responseMessage);
                        return;
                        break;
                    default:
                        responseMessage = [NSString stringWithFormat:@"Splunk job status check API call returned unexpected status code: %ldl", (long)httpResponse.statusCode];
                        DDLogWarn(@"%@", responseMessage);
                        break;
                }
            }
            if(data != nil)
            {
                NSString *rawResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"%@", rawResult);
                DDLogDebug(@"Splunk job status check result: %@", rawResult);

                NSError *error = nil;

                id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

                if(error) {
                    DDLogError(@"Error parsing splunk job status check result");
                    DDLogDebug(@"%@", error);
                    return;
                }

                if(![object isKindOfClass:[NSDictionary class]])
                {
                    DDLogError(@"Splunk job status check result not in expected format");
                    return;
                }

                NSDictionary *result = (NSDictionary *)object;
                NSString *status = (NSString *)[self extractValueForKey:@"dispatchState" FromObject:result];
                if(status != nil)
                {
                    DDLogInfo(@"Job status of %@ returned for alert \"%@\"", status, job.alert.alertName);
                }
            }
        }
    }];

    [dataTask resume];

}

#pragma mark utility methods

-(NSObject *) extractValueForKey: (NSString *) key FromObject: (NSDictionary *) dictionary
{

    for (NSString *dictKey in [dictionary allKeys]) {

        if([[NSString stringWithString:dictKey] isEqualToString:key])
            return [dictionary objectForKey:key];

        id value = [dictionary objectForKey:dictKey];
        if([value isKindOfClass:[NSDictionary class]])
        {
            id retValue = [self extractValueForKey:key FromObject:(NSDictionary *)value];
            if(retValue != nil)
                return retValue;

        } else if([value isKindOfClass:[NSArray class]])
        {
            for (id object in (NSArray *) value) {
                if([object isKindOfClass:[NSDictionary class]])
                {
                    id retValue = [self extractValueForKey:key FromObject:(NSDictionary *)object];
                    if(retValue != nil)
                        return retValue;
                }
            }
        }
    }
    return nil;
}

-(NSURL *) createSplunkURL: (Settings *)currentSettings withEndpoint: (NSString *) endpoint withOutputType: (NSString * _Nullable) outputType
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", currentSettings.splunkServer, [NSNumber numberWithInteger: currentSettings.splunkPortOverride], endpoint];

    if(outputType)
        urlString = [NSString stringWithFormat:@"%@?output_mode=%@", urlString, outputType];

    NSURL *url = [NSURL URLWithString:urlString];


    return url;
}

void RunBlockAfterDelay(int delay, void (^block)(void))
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@end
