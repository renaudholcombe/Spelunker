//
//  LogViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogViewController.h"
#import "AppDelegate.h"

@implementation LogViewController

@synthesize logTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    logger = ((AppDelegate *) [NSApplication sharedApplication].delegate).textViewLogger;
    logger.textView = logTextView;
}


- (IBAction)clearLogButton:(id)sender {
    [logTextView setString:@""];
}
@end
