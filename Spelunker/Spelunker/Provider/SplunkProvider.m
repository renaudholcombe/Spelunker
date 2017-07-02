//
//  SplunkProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkProvider.h"
#import "AlertHandler.h"
#import "SplunkSearchResult.h"

@implementation SplunkProvider

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

-(void) searchSplunk:(NSString *)searchString withAlert: (Alert *) alert
{
    //create job
    NSURL *createUrl = [self createSplunkURL: settings withEndpoint:@"/services/search/jobs/export/" withOutputType:@"raw"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:createUrl];
    request.HTTPMethod = @"POST";
    searchString = [NSString stringWithFormat:@"search=%@", searchString];
    request.HTTPBody = [searchString dataUsingEncoding:NSUTF8StringEncoding];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){

        if(error != nil)
        {
            DDLogError(@"Error executing splunk search job");
            DDLogDebug(@"%@", error);
            return;

        } else {

            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if(httpResponse.statusCode != 200)
            {
                NSString *responseMessage;
                switch(httpResponse.statusCode)
                {
                    case 401:
                    case 403:
                        responseMessage = @"Splunk search API call returned unauthorized";
                        DDLogError(@"%@",responseMessage);
                        break;
                    case 400:
                        responseMessage = @"Splunk search API returned \"Bad Request\". Confirm your search string";
                        DDLogError(@"%@", responseMessage);
                        return;
                        break;
                    default:
                        responseMessage = [NSString stringWithFormat:@"Splunk search API call returned unexpected status code: %ldl", (long)httpResponse.statusCode];
                        DDLogWarn(@"%@", responseMessage);
                        break;
                }

            }
            if(data != nil)
            {
                SplunkSearchResult *result = [[SplunkSearchResult alloc] initWithAlert:alert withResult:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ProcessSplunkResult" object:result];
                DDLogInfo(@"Received query results for alert: %@", alert.alertName);
            }
        }

    }];

    [dataTask resume];
}

#pragma mark utility methods

-(NSURL *) createSplunkURL: (Settings *)currentSettings withEndpoint: (NSString *) endpoint withOutputType: (NSString * _Nullable) outputType
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", currentSettings.splunkServer, [NSNumber numberWithInteger: currentSettings.splunkPortOverride], endpoint];

    if(outputType)
        urlString = [NSString stringWithFormat:@"%@?output_mode=%@", urlString, outputType];

    NSURL *url = [NSURL URLWithString:urlString];


    return url;
}

@end
