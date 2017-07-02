//
//  SplunkSearchResult.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkSearchResult.h"

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
