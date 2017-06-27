//
//  AppDelegate.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogicManager.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    LogicManager *logicManager;
}

@property NSMutableArray *alertList;

- (IBAction)showPreferences:(id)sender;
- (IBAction)showLogViewer:(id)sender;

@end

