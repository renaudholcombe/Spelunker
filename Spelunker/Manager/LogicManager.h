//
//  LogicManager.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"
#import "EmailProvider.h"
#import "SplunkProvider.h"
#import "Alert.h"
#import "Settings.h"

@interface LogicManager : NSObject
{
    DataProvider *dataProvider;
    EmailProvider *emailProvider;
    SplunkProvider *splunkProvider;
    NSMutableDictionary *alertDictionary;
}

+(id)sharedManager;

//alerts
-(void) getAlertList;
-(void) saveAlert: (Alert *)alert;

//settings
-(Settings *) loadSettings;
-(void) saveSettings: (Settings *) settings;

//email
-(void) testEmail: (Settings *) settings;

//splunk
-(void) testSplunkConnection: (Settings *)settings;

@end
