//
//  LogicManager.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogicManager.h"
#import "Constants.h"
#import "SplunkSearchResult.h"

@implementation LogicManager

#pragma mark initialization methods

+ (id) sharedManager {
    static LogicManager *logicManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logicManager = [[LogicManager alloc] init];
    });
    return logicManager;
}

-(id) init
{
    self = [super init];

    dataProvider = [DataProvider sharedProvider];
    emailProvider = [EmailProvider sharedProvider];
    splunkProvider = [SplunkProvider sharedProvider];

    //initialize master array
    //timer initialization logic will need to go here
    alertDictionary = [[NSMutableDictionary alloc] init];
    for (Alert *alert in [dataProvider getAlerts])
    {
        [alertDictionary setObject:alert forKey:alert.alertId];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSplunkResult:) name:@"ProcessSplunkResult" object:nil];

    [self initTimers];

    return self;
}

#pragma mark alert methods

-(void) getAlertList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:[alertDictionary allValues]];
}

-(void) saveAlert:(Alert *)alert
{
    [alertDictionary setObject:alert forKey:alert.alertId];
    [splunkProvider searchSplunk:alert.searchString withAlertId: (NSUUID *) alert.alertId];
    //timer modification code is going to live here;
    [self saveAlertList:[alertDictionary allValues]];
}

#pragma mark settings methods

-(Settings *)loadSettings
{
    return [dataProvider getSettings];
}

-(void) saveSettings:(Settings *)settings
{
    [dataProvider saveSettings:settings];
}

#pragma mark email methods
-(void) testEmail:(Settings *)settings
{
    [emailProvider sendTestEmail:settings];
}

#pragma mark splunk methods
-(void) testSplunkConnection:(Settings *)settings
{
    [splunkProvider testConnection:settings];
}

#pragma mark internal methods

-(void) saveAlertList:(NSArray *)alertList
{
    [dataProvider saveAlerts:alertList];
}

-(void) processSplunkResult: (NSNotification *)notifiction
{
    SplunkSearchResult *searchResult = notifiction.object;

    NSString *emailBody = [self createEmailBody:searchResult];


}

-(NSString *) createEmailBody: (SplunkSearchResult *) searchResult
{
    NSString *body = [[NSString alloc] init];
    Alert *alert = [alertDictionary objectForKey:searchResult.alertId];
    if(alert == nil || searchResult.result == nil)
    {
        DDLogError(@"Could not find alert/result for splunk query");
        return @"";
    }

    body = [NSString stringWithFormat:@"Spelunker results for alert: %@\n\n", alert.alertName];
    body = [body stringByAppendingString:searchResult.result];

    return body;
}

-(void) initTimers
{

}

@end
