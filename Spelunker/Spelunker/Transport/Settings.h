//
//  Settings.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

//splunk settings
@property (nonatomic, retain, setter=setSplunkServer:) NSString *splunkServer;
@property (nonatomic, retain, setter=setSplunkUsername:) NSString *splunkUsername;
@property (nonatomic, retain, setter=setSplunkPassword:) NSString *splunkPassword;
@property (nonatomic) NSInteger splunkPortOverride;

//smtp settings
@property (nonatomic, retain, setter=setSmtpServer:) NSString *smtpServer;
@property (nonatomic) BOOL smtpUseSSL;
@property (nonatomic, retain, setter=setSmtpEmailAddress:) NSString *smtpEmailAddress;
@property (nonatomic, retain, setter=setSmtpUsername:) NSString *smtpUsername;
@property (nonatomic, retain, setter=setSmtpPassword:) NSString *smtpPassword;

@end
