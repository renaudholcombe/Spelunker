//
//  SplunkSearchResult.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkReturnTypes.h"

#pragma mark search job result

@implementation SplunkSearchResult

@synthesize alert, result;

-(id) initWithAlert: (Alert *) searchAlert withResult: (NSString *) queryResult
{
    self = [super init];
    alert = searchAlert;
    result = queryResult;

    return self;
}

@end

#pragma mark search job creation result

@implementation SplunkJob

@synthesize jobId, alert;

-(id) initWithAlert: (Alert *) searchAlert withJobId: (NSDecimalNumber *) jId
{
    self = [super init];
    alert = searchAlert;
    jobId = jId;

    return self;
}

@end
