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

//rawResult	__NSCFString *	@"{\"links\":{},\"origin\":\"https://192.168.13.113:8089/services/search/jobs\",\"updated\":\"2017-07-02T15:57:35-04:00\",\"generator\":{\"build\":\"aeae3fe0c5af\",\"version\":\"6.6.1\"},\"entry\":[{\"name\":\"search (source=suricata-wan earliest=-1h) |\\tstats count by alertType | sort -num(count) \",\"id\":\"https://192.168.13.113:8089/services/search/jobs/1499025427.1248\",\"updated\":\"2017-07-02T15:57:35.000-04:00\",\"links\":{\"alternate\":\"/services/search/jobs/1499025427.1248\",\"search.log\":\"/services/search/jobs/1499025427.1248/search.log\",\"events\":\"/services/search/jobs/1499025427.1248/events\",\"results\":\"/services/search/jobs/1499025427.1248/results\",\"results_preview\":\"/services/search/jobs/1499025427.1248/results_preview\",\"timeline\":\"/services/search/jobs/1499025427.1248/timeline\",\"summary\":\"/services/search/jobs/1499025427.1248/summary\",\"control\":\"/services/search/jobs/1499025427.1248/control\"},\"published\":\"2017-07-02T15:57:07.000-04:00\",\"author\":\"admin\",\"content\":{\"canSummarize\":true,\"cursorTime\":\"1969-12-31T19:00:00.000-05:00\",\"default"	0x0000000101087000

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
