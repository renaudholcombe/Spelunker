//
//  AppDelegate.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesViewController.h"

@implementation AppDelegate

@synthesize alertList;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    logicManager = [LogicManager sharedManager];
    [logicManager getAlertList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Settings updated" object: [logicManager loadSettings]];
    }


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showPreferences:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPreferences" object:nil];
}

- (IBAction)showLogViewer:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenLogViewer" object:nil];

    NSStoryboard *storyBoard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    logViewerWindow = [storyBoard instantiateControllerWithIdentifier:@"LogViewerWindow"];
    [logViewerWindow showWindow:self];
}

@end
