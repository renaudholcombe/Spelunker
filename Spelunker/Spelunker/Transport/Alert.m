//
//  Alert.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "Alert.h"

@implementation Alert

@synthesize alertId, alertName, alertType, scheduleTime, searchString, isValid, timer;

-(id) init
{
    self = [super init];
    alertId = [NSUUID UUID];

    [self SetDefaults];

    return self;
}

-(void)SetDefaults
{
    alertName = @"Default alert";
    alertType = Polling;
    searchString = @"* earliest=-1h";
    isValid = false;
}

@end

@implementation AlertList

@end
