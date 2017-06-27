//
//  LogViewController.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "UITextViewLogger.h"

@interface LogViewController : NSViewController {
    UITextViewLogger *logger;
}

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;

- (IBAction)clearLogButton:(id)sender;

@end
