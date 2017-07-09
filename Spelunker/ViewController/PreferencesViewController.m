//
//  PreferencesViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "PreferencesViewController.h"

@implementation PreferencesViewController

@synthesize splunkPortOverride, splunkPassword, splunkUsername, splunkAddressTextField;
@synthesize emailUseSSL, emailServer, emailPassword, emailUsername, emailAddress, emailPortOverride, emailFromAddress;

- (void)viewDidLoad {
    [super viewDidLoad];
    logicManager = [LogicManager sharedManager];
    [self loadSettings];
}

-(void) loadSettings
{
    Settings *settings = [logicManager loadSettings];

    //set controls
    splunkAddressTextField.stringValue = settings.splunkServer;

    if(settings.splunkPortOverride != 8089)
        splunkPortOverride.integerValue = settings.splunkPortOverride;
    else
        splunkPortOverride.stringValue = @"";

    splunkUsername.stringValue = settings.splunkUsername;
    splunkPassword.stringValue = settings.splunkPassword;

    emailServer.stringValue = settings.smtpServer;
    emailUseSSL.integerValue = settings.smtpUseSSL;
    emailUsername.stringValue = settings.smtpUsername;
    emailPassword.stringValue = settings.smtpPassword;
    emailAddress.stringValue = settings.smtpEmailAddress;
    emailFromAddress.stringValue = settings.smtpFromAddress;
    if(settings.smtpPortOverride != 587)
        emailPortOverride.integerValue = settings.smtpPortOverride;
    else
        emailPortOverride.stringValue = @"";
}

#pragma mark action methods

- (IBAction)cancelAction:(id)sender {
    [self dismissController:self];
}

- (IBAction)saveAction:(id)sender {

    Settings *settings = [self getSettingsFromControls];
    [logicManager saveSettings:settings];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"Settings updated" object:settings];

    [self dismissController:self];
}

-(void) registerNotifications
{

}

-(Settings *)getSettingsFromControls
{
    Settings *settings = [[Settings alloc] init];

    settings.splunkServer = splunkAddressTextField.stringValue;
    settings.splunkPortOverride = (splunkPortOverride.integerValue == 0) ? 8089: splunkPortOverride.integerValue;
    settings.splunkPassword = splunkPassword.stringValue;
    settings.splunkUsername = splunkUsername.stringValue;

    settings.smtpEmailAddress = emailAddress.stringValue;
    settings.smtpFromAddress = emailFromAddress.stringValue;
    settings.smtpUsername = emailUsername.stringValue;
    settings.smtpPassword = emailPassword.stringValue;
    settings.smtpServer = emailServer.stringValue;
    settings.smtpUseSSL = emailUseSSL.integerValue;
    settings.smtpPortOverride = (emailPortOverride.integerValue == 0) ? 587 : emailPortOverride.integerValue;

    return settings;
}

- (IBAction)testEmail:(id)sender {
    [logicManager testEmail:[self getSettingsFromControls]];
}

- (IBAction)testSplunk:(id)sender {
    [logicManager testSplunkConnection:[self getSettingsFromControls]];
}
@end
