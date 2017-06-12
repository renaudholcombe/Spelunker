//
//  Alert.m
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "Alert.h"

@implementation Alert

@synthesize alertId, alertName, alertType, scheduleTime, searchString, isValid;

-(id) init
{
    self = [super init];
    alertId = [NSUUID UUID];
    return self;
}

@end

@implementation AlertList

@end
