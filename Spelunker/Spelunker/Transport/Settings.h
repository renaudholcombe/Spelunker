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
@property (nonatomic, retain) NSString *splunkAddress;
@property (nonatomic, retain) NSString *splunkUsername;
@property (nonatomic, retain) NSString *splunkPassword;
@property (nonatomic) NSInteger splunkPortOverride;

//smtp settings
@property (nonatomic, retain) NSString *smtpServer;
@property (nonatomic) BOOL smtpUseSSL;
@property (nonatomic, retain) NSString *smtpUsername;
@property (nonatomic, retain) NSString *smtpPassword;
@property (nonatomic) NSInteger smtpPortOverride;




@end
