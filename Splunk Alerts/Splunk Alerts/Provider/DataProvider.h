//
//  AlertProvider.h
//  Splunk Alerts
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataProvider : NSObject
{
    NSUserDefaults *userDefaults;
}

+(id) sharedProvider;

-(NSArray *) getAlerts;
-(void) saveAlerts: (NSArray *) alerts;

@end
