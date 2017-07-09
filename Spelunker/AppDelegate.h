//
//  AppDelegate.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LogicManager.h"
#import "UITextViewLogger.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    LogicManager *logicManager;
    NSWindowController *logViewerWindow;
}

@property NSMutableArray *alertList;
@property UITextViewLogger *textViewLogger;



- (IBAction)showPreferences:(id)sender;

@end

