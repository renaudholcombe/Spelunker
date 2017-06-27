//
//  LogViewController.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LogViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *logTextView;

- (IBAction)clearLogButton:(id)sender;

@end
