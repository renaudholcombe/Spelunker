//
//  Alert.h
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Alert : NSObject

@property (nonatomic, retain) NSString *alertName;
@property (nonatomic) AlertType alertType;
@property (nonatomic, retain) NSDate *scheduleTime;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic) Boolean isValid;

@end
