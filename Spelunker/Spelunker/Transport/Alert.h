//
//  Alert.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "JSONModel/JSONModel.h"

@protocol Alert;

@interface Alert :JSONModel

@property (nonatomic, retain) NSUUID *alertId;
@property (nonatomic, retain) NSString *alertName;
@property (nonatomic) AlertType alertType;
@property (nonatomic, retain) NSDate *scheduleTime;
@property (nonatomic) NSInteger schedulerTimeInterval; //hours
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic) BOOL isValid;
@property (nonatomic, retain) NSTimer <Ignore> *timer;

-(NSDate *) nextFireTime;

@end

@interface AlertList: JSONModel

@property (nonatomic) NSArray <Alert> *alertList;


@end
