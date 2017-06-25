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
    return emailProvider;
}

-(void)sendTestEmail:(Settings *)settings
{
    MCOSMTPSession *session = [[MCOSMTPSession alloc] init];

//debug only
/*    [session setConnectionLogger:^(void * connectionID, MCOConnectionLogType type, NSData * data){
        NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
 */

    session.hostname = settings.smtpServer;
    session.port = (unsigned int) settings.smtpPortOverride;
    session.username = settings.smtpUsername;
    session.password = settings.smtpPassword;
    session.connectionType = (settings.smtpUseSSL) ? MCOConnectionTypeStartTLS : MCOConnectionTypeClear;

    MCOMessageBuilder *builder = [[MCOMessageBuilder alloc] init];
    [builder.header setFrom:[MCOAddress addressWithDisplayName:nil mailbox:settings.smtpFromAddress]];
    NSMutableArray *to = [NSMutableArray arrayWithArray:@[ [MCOAddress addressWithMailbox:settings.smtpEmailAddress]]];
    [builder.header setTo:to];
    [builder.header setSubject:@"Test email from Spelunker"];
    [builder setTextBody:@"You're ready to receive alerts!"];

    NSData *rfc822Data = [builder data];

    MCOSMTPSendOperation *sendOperation = [session sendOperationWithData:rfc822Data];

    [sendOperation start:^(NSError *error){
        if(error)
        {
            NSLog(@"Error sending test email: %@", error);
            [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error sending test email" withError:error]];
        } else
        {
            NSLog(@"Email sent successfully!");
            [AlertHandler showAlert:@"Test email sent successfully"];
        }
    }];
}

@end
