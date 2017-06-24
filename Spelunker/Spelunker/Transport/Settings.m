//
//  Settings.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "Settings.h"

@implementation Settings

@synthesize splunkServer, splunkPassword, splunkUsername, splunkPortOverride;

@synthesize smtpServer, smtpUseSSL, smtpPassword, smtpUsername, smtpEmailAddress;

-(id) init
{
    self = [super init];
    splunkServer = @"";
    splunkUsername = @"";
    splunkPassword = @"";

    smtpPassword = @"";
    smtpUsername = @"";
    smtpServer = @"";
    smtpEmailAddress = @"";

    return self;
}

-(void)setSplunkServer:(NSString *)server
{
    if(server != nil)
        splunkServer = server;

}

-(void)setSplunkUsername:(NSString *)username
{
    if(username != nil)
        splunkUsername = username;

}

-(void)setSmtpServer:(NSString *)server
{
    if(server != nil)
        smtpServer = server;
}

-(void)setSmtpUsername:(NSString *)username
{
    if(username != nil)
        smtpUsername = username;
}

-(void)setSmtpEmailAddress:(NSString *)emailAddress
{
    if(emailAddress != nil)
        smtpEmailAddress = emailAddress;
}

@end
