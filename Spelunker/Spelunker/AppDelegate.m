//
//  AppDelegate.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "AppDelegate.h"
#import "SpelunkerLogFormatter.h"

@implementation AppDelegate

@synthesize alertList, textViewLogger;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [self initializeLogging];

    logicManager = [LogicManager sharedManager];
    [logicManager getAlertList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Settings updated" object: [logicManager loadSettings]];

    }


-(void) initializeLogging
{
    textViewLogger = [[UITextViewLogger alloc] initWithLogFormatter:[[SpelunkerLogFormatter alloc] init]];

    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60*60*24; //24 hours
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [fileLogger setLogFormatter:[[SpelunkerLogFormatter alloc] init]];

    DDASLLogger *aslLogger = [DDASLLogger sharedInstance];
    [aslLogger setLogFormatter:[[SpelunkerLogFormatter alloc] init]];

    DDTTYLogger *ttyLogger = [DDTTYLogger sharedInstance];
    [ttyLogger setLogFormatter:[[SpelunkerLogFormatter alloc] init]];

    [DDLog addLogger:textViewLogger];
    [DDLog addLogger:fileLogger];
    [DDLog addLogger:aslLogger];
    [DDLog addLogger:ttyLogger];

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showPreferences:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenPreferences" object:nil];
}


@end
