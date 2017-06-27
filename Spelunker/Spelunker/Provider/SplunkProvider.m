//
//  SplunkProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkProvider.h"
#import "AlertHandler.h"

@implementation SplunkProvider

+(id) sharedProvider
{
    static SplunkProvider *splunkProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        splunkProvider = [[SplunkProvider alloc] init];
    });

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
    Settings *settings = notification.object;

    sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *authString = [NSString stringWithFormat:@"%@:%@", settings.splunkUsername, settings.splunkPassword];

    NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authHeader = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];

    sessionConfiguration.HTTPAdditionalHeaders = @{
                                                   @"Authorization": authHeader
                                                   };
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration];

}

-(void) testConnection:(Settings *)settings
{
    //try to get a login token
    NSURL *url = [self createSplunkURL:settings withEndpoint:@"/services/search/jobs/"];

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
            [AlertHandler showAlert:@"Splunk authentication failed!"];
            return;
        }

        if(httpResponse.statusCode == 200)
            [AlertHandler showAlert:@"Splunk connection succeeded!"];

    }];

    [dataTask resume];
}

-(NSURL *) createSplunkURL: (Settings *)settings withEndpoint: (NSString *) endpoint
{
    NSString *urlString = [NSString stringWithFormat:@"%@:%@%@", settings.splunkServer, [NSNumber numberWithInteger: settings.splunkPortOverride], endpoint];

    NSURL *url = [NSURL URLWithString:urlString];


    return url;
}

@end
