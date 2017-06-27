//
//  LogViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "LogViewController.h"


@implementation LogViewController

@synthesize logTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [logTextView setString:@""]; //clear out
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appendLog:) name:@"LogMessage" object:nil];
}

-(void)appendLog: (NSNotification *)notification
{
    [[logTextView textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:notification.object]];

}

- (IBAction)clearLogButton:(id)sender {
    [logTextView setString:@""];
}
@end
