//
//  SplunkSearchResult.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alert.h"

#pragma mark search job result

@interface SplunkSearchResult : NSObject

@property (nonatomic, retain) Alert *alert;
@property (nonatomic, retain) NSString *result;

-(id) initWithAlert: (Alert *) searchAlert withResult: (NSString *) queryResult;

@end

#pragma mark search job creation result

@interface SplunkJob : NSObject

@property (nonatomic, retain) Alert *alert;
@property (nonatomic, retain) NSDecimalNumber *jobId;

-(id) initWithAlert: (Alert *) searchAlert withJobId: (NSDecimalNumber *) jId;

@end


#pragma mark search job status result

//might not need this one
@interface SplunkJobStatus : NSObject

@property (nonatomic, retain) Alert *alert;
@property (nonatomic, retain) NSDecimalNumber *jobId;

-(id) initWithAlert: (Alert *) searchAlert withJobId: (NSDecimalNumber *) jId;

@end
