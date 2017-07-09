//
//  SplunkJobStatusCheckOperation.h
//  Spelunker
//
//  Created by Renaud Holcombe on 7/2/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SplunkProvider.h"
#import "SplunkReturnTypes.h"


@interface SplunkJobStatusCheckOperation : NSOperation {
    SplunkProvider *splunkProvider;
    SplunkJob *job;
    NSInteger triesRemaining;

    BOOL executing;
    BOOL finished;
}

-(id) initWithJob: (SplunkJob *) splunkJob triesRemaining: (NSInteger) tries;

@end
