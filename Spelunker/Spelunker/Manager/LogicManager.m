//
//  LogicManager.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogicManager.h"
#import "Alert.h"
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

    return self;
}

-(void) getAlertList
{
    NSArray *alertList = [dataProvider getAlerts];
    if(alertList.count == 0)
    {
        //dummy code
        Alert *alert = [[Alert alloc] init];
        [alert SetDefaults];

        alertList =  @[alert];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:alertList];
}

-(void) saveAlertList:(NSArray *)alertList
{
    [dataProvider saveAlerts:alertList];
}

@end
