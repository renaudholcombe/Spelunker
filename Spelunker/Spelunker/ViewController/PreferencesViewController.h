//
//  PreferencesViewController.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogicManager.h"
#import "Settings.h"

@interface PreferencesViewController : NSViewController {
    LogicManager *logicManager;
}

@property (weak) IBOutlet NSTextField *splunkAddressTextField;
@property (weak) IBOutlet NSTextField *splunkPortOverride;
@property (weak) IBOutlet NSTextField *splunkUsername;
@property (weak) IBOutlet NSSecureTextField *splunkPassword;

@property (weak) IBOutlet NSTextField *emailServer; //needs to change to emailServer 
@property (weak) IBOutlet NSButton *emailUseSSL;
@property (weak) IBOutlet NSTextField *emailUsername;
@property (weak) IBOutlet NSSecureTextField *emailPassword;
@property (weak) IBOutlet NSTextField *emailAddress;


- (IBAction)cancelAction:(id)sender;
- (IBAction)saveAction:(id)sender;

@end
