//
//  SplunkSearchResult.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Alert.h"

@interface SplunkSearchResult : NSObject

@property (nonatomic, retain) Alert *alert;
@property (nonatomic, retain) NSString *result;

-(id) initWithAlert: (Alert *) searchAlert withResult: (NSString *) queryResult;

@end
