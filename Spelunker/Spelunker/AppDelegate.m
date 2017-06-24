//
//  AppDelegate.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize alertList;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    logicManager = [LogicManager sharedManager];
    [logicManager getAlertList];
    }


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (IBAction)showPreferences:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPreferences" object:nil];
}

@end
