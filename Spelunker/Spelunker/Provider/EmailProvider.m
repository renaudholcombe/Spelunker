//
//  EmailProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "EmailProvider.h"
#import <MailCore/MailCore.h>
#import "AlertHandler.h"

@implementation EmailProvider

+(id) sharedProvider
{
    static EmailProvider *emailProvider;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emailProvider = [[EmailProvider alloc] init];
    });

    DDLogInfo(@"EmailProvider initialized");

    return emailProvider;
}

#pragma mark internal methods

-(id) init
{
    self = [super init];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSession:) name:@"Settings updated" object:nil];

    return self;
}

-(void) refreshSession: (NSNotification *)notification
{
    settings = notification.object;

    session = [[MCOSMTPSession alloc] init];
    session.hostname = settings.smtpServer;
    session.port = (unsigned int) settings.smtpPortOverride;
    session.username = settings.smtpUsername;
    session.password = settings.smtpPassword;
    session.connectionType = (settings.smtpUseSSL) ? MCOConnectionTypeStartTLS : MCOConnectionTypeClear;
    
}

#pragma mark email methods

-(void)sendTestEmail:(Settings *)testSettings
{
    MCOSMTPSession *testSession = [[MCOSMTPSession alloc] init];

    testSession.hostname = testSettings.smtpServer;
    testSession.port = (unsigned int) testSettings.smtpPortOverride;
    testSession.username = testSettings.smtpUsername;
    testSession.password = testSettings.smtpPassword;
    testSession.connectionType = (testSettings.smtpUseSSL) ? MCOConnectionTypeStartTLS : MCOConnectionTypeClear;

    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    [builder.header setFrom:[MCOAddress addressWithDisplayName:nil mailbox:testSettings.smtpFromAddress]];
    NSMutableArray *to = [NSMutableArray arrayWithArray:@[ [MCOAddress addressWithMailbox:testSettings.smtpEmailAddress]]];
    [builder.header setTo:to];
    [builder.header setSubject:@"Test email from Spelunker"];
    [builder setTextBody:@"You're ready to receive alerts!"];

    NSData *rfc822Data = [builder data];

    MCOSMTPSendOperation *sendOperation = [testSession sendOperationWithData:rfc822Data];

    [sendOperation start:^(NSError *error){
        if(error)
        {
            DDLogError(@"Error sending test email: %@", error);
            [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error sending test email" withError:error]];
        } else
        {
            DDLogInfo(@"Email sent successfully!");
            [AlertHandler showAlert:@"Test email sent successfully"];
        }
    }];
}

-(void) sendEmailWithAlertName: (NSString *) alertName withBody: (NSString *)body
{
    NSString *subject = @"Spelunker alert: ";

    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    [builder.header setFrom:[MCOAddress addressWithDisplayName:nil mailbox:settings.smtpFromAddress]];
    NSMutableArray *to = [NSMutableArray arrayWithArray:@[ [MCOAddress addressWithMailbox:settings.smtpEmailAddress]]];
    [builder.header setTo:to];
    [builder.header setSubject:[subject stringByAppendingString:alertName]];
    [builder setHTMLBody:body];

    NSData *rfc822Data = [builder data];

    MCOSMTPSendOperation *sendOperation = [session sendOperationWithData:rfc822Data];

    [sendOperation start:^(NSError *error){
        if(error)
        {
            DDLogError(@"Error sending email to %@ for alert \"%@\": %@", settings.smtpEmailAddress,alertName,error);
        } else
        {
            DDLogInfo(@"Email sent successfully to %@ for alert \"%@\"!", settings.smtpEmailAddress,alertName);
        }
    }];

}

@end
