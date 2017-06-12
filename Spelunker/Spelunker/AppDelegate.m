//
//  AppDelegate.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize alertList;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    logicManager = [LogicManager sharedManager];
    alertList = [[NSMutableArray alloc] initWithArray:[logicManager getAlertList]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadAlerts" object:alertList];
    }


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
