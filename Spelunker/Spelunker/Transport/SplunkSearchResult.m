//
//  SplunkSearchResult.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkSearchResult.h"

@implementation SplunkSearchResult

@synthesize alertId, result;

-(id) initWithAlertId: (NSUUID *) alertid withResult: (NSString *) queryResult
{
    self = [super init];
    alertId = alertid;
    result = queryResult;

    return self;
}

@end
