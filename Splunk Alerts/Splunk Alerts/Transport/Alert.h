//
//  Alert.h
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <JSONModel.h>

@protocol Alert;

@interface Alert :JSONModel

@property (nonatomic, retain) NSUUID *alertId;
@property (nonatomic, retain) NSString *alertName;
@property (nonatomic) AlertType alertType;
@property (nonatomic, retain) NSDate *scheduleTime;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic) BOOL isValid;

@end

@interface AlertList: JSONModel

@property (nonatomic) NSArray <Alert> *alertList;

@end
