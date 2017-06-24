//
//  SplunkProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkProvider.h"

@implementation SplunkProvider

+(id) sharedProvider
{
    static SplunkProvider *splunkProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        splunkProvider = [[SplunkProvider alloc] init];
    });

    return splunkProvider;
}

-(id) init
{
    self = [super init];
    //do my startup stuff

    return self;
}

@end
