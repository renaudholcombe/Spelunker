//
//  LogicManager.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogicManager.h"
#import "Constants.h"

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

    //initialize master array
    //timer initialization logic will need to go here
    alertDictionary = [[NSMutableDictionary alloc] init];
    for (Alert *alert in [dataProvider getAlerts])
    {
        [alertDictionary setObject:alert forKey:alert.alertId];
    }

    return self;
}

-(void) getAlertList
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:[alertDictionary allValues]];
}

-(void) saveAlert:(Alert *)alert
{
    [alertDictionary setObject:alert forKey:alert.alertId];
    //timer modification code is going to live here;
    [self saveAlertList:[alertDictionary allValues]];
}

#pragma mark internal methods

-(void) saveAlertList:(NSArray *)alertList
{
    [dataProvider saveAlerts:alertList];
}

@end
