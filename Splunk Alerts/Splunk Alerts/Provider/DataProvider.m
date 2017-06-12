//
//  AlertProvider.m
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "DataProvider.h"
#import "Alert.h"

@implementation DataProvider

NSString * const ALERTKEY = @"Alerts";

+ (id)sharedProvider
{
    static DataProvider *alertProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertProvider = [[DataProvider alloc] init];
    });
    return alertProvider;
}

-(id) init
{
    self = [super init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

-(void)saveAlerts:(NSArray *)alerts
{
    AlertList *list = [[AlertList alloc] init];
    [list.alertList arrayByAddingObjectsFromArray:alerts];

    NSString *jsonString = [list toJSONString];
    [userDefaults setObject:jsonString forKey:ALERTKEY];
}

-(NSArray *) getAlerts
{
    NSString *alertsString = [userDefaults objectForKey:ALERTKEY];
    if(alertsString == nil)
        return [[NSArray alloc] init];

    NSError *error = nil;
    AlertList *alertList = [[AlertList alloc] initWithString:alertsString error:&error];

    return alertList.alertList;
}

@end
