//
//  SplunkJobStatusCheckOperation.m
//  Spelunker
//
//  Created by Renaud Holcombe on 7/2/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SplunkJobStatusCheckOperation.h"

@implementation SplunkJobStatusCheckOperation

-(id) initWithJob: (SplunkJob *) splunkJob triesRemaining: (NSInteger) tries
{
    self = [super init];

    splunkProvider = [SplunkProvider sharedProvider];
    job = splunkJob;
    triesRemaining = tries;

    executing = NO;
    finished = NO;

    return self;
}

#pragma mark class methods

-(void)start
{
    if(self.isCancelled)
    {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    [self willChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

-(void)main
{
    
}

-(BOOL)isConcurrent
{
    return YES;    //Default is NO so overriding it to return YES;
}

-(BOOL)isExecuting{
    return executing;
}

-(BOOL)isFinished{
    return finished;
}



@end
