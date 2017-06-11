//
//  LogicManager.m
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogicManager.h"
#import "Alert.h"
#import "Constants.h"

@implementation LogicManager

+ (id) sharedManager {
    static LogicManager *logicManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logicManager = [[LogicManager alloc] init];
    });
    return logicManager;
}

-(NSArray *) getAlertList
{
    //dummy code
    Alert *alert = [[Alert alloc] init];
    alert.alertName = @"dummy 1";
    alert.alertType = Polling;
    alert.searchString = @"test search string";
    alert.isValid = false;

    return @[alert];
    
}

@end
