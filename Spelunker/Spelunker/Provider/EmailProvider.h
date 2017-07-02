//
//  EmailProvider.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MailCore/MailCore.h>
#import "Settings.h"

@interface EmailProvider : NSObject {
    MCOSMTPSession *session;
    Settings *settings;
}

+(id) sharedProvider;

-(void) sendTestEmail: (Settings *)testSettings;
-(void) sendEmailWithAlertName: (NSString *) alertName withBody: (NSString *)body;

@end
