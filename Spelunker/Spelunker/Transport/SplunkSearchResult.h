//
//  SplunkSearchResult.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/27/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SplunkSearchResult : NSObject

@property (nonatomic, retain) NSUUID *alertId;
@property (nonatomic, retain) NSString *result;

-(id) initWithAlertId: (NSUUID *) alertid withResult: (NSString *) queryResult;

@end
