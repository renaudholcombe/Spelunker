//
//  LogicManager.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogicManager.h"
#import "Constants.h"
#import "SplunkReturnTypes.h"

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

    //load settings for the providers
    Settings *settings = [self loadSettings];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Settings updated" object:settings];

    //setup notification handlers
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processSplunkResult:) name:@"Process splunk result" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fireAlert:) name:@"Fire alert" object:nil];

    [self initTimers];

    return self;
}

#pragma mark alert methods

-(void) getAlertList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:[[NSArray alloc] initWithArray: [alertDictionary allValues]]];
}

-(void) saveAlert:(Alert *)alert
{

    Alert *oldAlert = [alertDictionary objectForKey:alert.alertId];

    if(oldAlert != nil)
    {
        [alert.timer invalidate];
    }

    [alertDictionary setObject:alert forKey:alert.alertId];

    [self saveAlertList:[alertDictionary allValues]];

    [self initTimer:alert];

}

-(void) saveAlertList:(NSArray *)alertList
{
    [dataProvider saveAlerts:alertList];
}

-(void) deleteAlert:(NSUUID *)alertId
{
    Alert *alert = [alertDictionary valueForKey:[alertId UUIDString]];
    [alert.timer invalidate];
    [alertDictionary removeObjectForKey:alertId];
    [self saveAlertList:[alertDictionary allValues]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:[[NSArray alloc] initWithArray: [alertDictionary allValues]]];
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

-(void) processSplunkResult: (NSNotification *)notifiction
{
    SplunkSearchResult *searchResult = notifiction.object;

    if(searchResult.alert.alertType == Polling)
    {
        NSDictionary *resultsDictionary = (NSDictionary *) [searchResult.result objectForKey:@"results"];
        if(resultsDictionary.count == 0)
            return;
    }

    NSString *emailBody = [self createEmailBody:searchResult];
    [emailProvider sendEmailWithAlertName: searchResult.alert.alertName withBody:emailBody];
}

-(void) fireAlert: (NSNotification *)notification
{
    Alert *alert = notification.object;
    [splunkProvider searchSplunk:alert];
}

#pragma mark utility methods

-(NSString *) createEmailBody: (SplunkSearchResult *) searchResult
{
    NSString *body = nil;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm zzz"];
    NSString *css = @"<style>p { font-family: arial, sans-serif;} table {font-family: arial, sans-serif;border-collapse: collapse;width: 100%;} td, th {border: 1px solid #dddddd;text-align: left;padding: 8px;} tr:nth-child(even) {background-color: #dddddd;}</style>";

    body = [NSString stringWithFormat:@"<html>%@<p><b>Spelunker results for alert \"%@\" executed at %@</b></p><br />", css,searchResult.alert.alertName, [formatter stringFromDate:[NSDate date]]];

    NSString *table = [self convertSplunkJsonToHtmlTable:[searchResult.result objectForKey:@"fields"] content:[searchResult.result objectForKey:@"results"]];

    body = [body stringByAppendingString:table];
    body = [body stringByAppendingString:@"</html>"];

    return body;
}

-(NSString *) convertSplunkJsonToHtmlTable: (NSArray *) rawFields content:(NSArray *)results
{

    //convert rawFields array to a flat array
    NSMutableArray *fields = [[NSMutableArray alloc] init];
    for (NSDictionary *fieldObject in rawFields) {
        NSString *fieldName = [fieldObject objectForKey:@"name"];
        if(fieldName != nil)
            [fields addObject:fieldName];
    }

    NSString *final = @"<table>%@%@</table>";
    NSString *header = nil;
    NSString *data = @"";

    header = @"<tr>";
    for (NSString *field in fields) {
        header = [header stringByAppendingString:[NSString stringWithFormat:@"<th>%@</th>", field]];
    }
    header = [header stringByAppendingString:@"</tr>"];

    for (NSDictionary *row in results) {
        data = [data stringByAppendingString:@"<tr>"];

        for (NSString *column in fields) {
            NSString *value = [row objectForKey:column];
            if(value == nil)
                value = @"";
            data = [data stringByAppendingString:[NSString stringWithFormat:@"<td>%@</td>", value]];
        }

        data = [data stringByAppendingString:@"</tr>"];
    }
    final = [NSString stringWithFormat:final, header, data];

    return final;
}

-(void) initTimers
{
    for (Alert *alert in [alertDictionary allValues]) {
        [self initTimer:alert];
    }
    DDLogInfo(@"All timers initialized");
}

-(void) initTimer: (Alert *)alert
{
    alert.timer = [[NSTimer alloc] initWithFireDate:[alert nextFireTime] interval:((alert.alertType == Polling)? 120: (alert.schedulerTimeInterval * 60 * 60)) target:self selector:@selector(alertTimerFired:) userInfo:alert repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:alert.timer forMode:NSDefaultRunLoopMode];

    DDLogInfo(@"Timer initialized for alert \"%@\"", alert.alertName);
}

-(void) alertTimerFired: (NSTimer *)timer
{
    if(timer.userInfo != nil)
        [splunkProvider searchSplunk:timer.userInfo];
    else
        DDLogWarn(@"Invalid alert schedule triggered");
}

@end
