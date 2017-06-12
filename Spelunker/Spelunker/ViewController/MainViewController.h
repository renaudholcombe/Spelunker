//
//  MainViewController.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AlertTableView.h"

@interface MainViewController : NSViewController<NSTableViewDelegate, NSTableViewDataSource>
{
    NSArray *alertList;
}

@property (weak) IBOutlet NSTextField *alertNameTextField;
@property (weak) IBOutlet NSButton *scheduledRadio;
@property (weak) IBOutlet NSButton *pollingRadio;
@property (weak) IBOutlet NSDatePicker *scheduledDatePicker;
@property (weak) IBOutlet NSScrollView *tableScrollView;
@property (weak) IBOutlet NSButton *addAlertButton;
@property (weak) IBOutlet NSButton *deleteAlertButton;
@property (weak) IBOutlet NSButton *saveAlertButton;
@property (weak) IBOutlet NSTextField *alertSearchTextField;
@property (weak) IBOutlet NSTextField *queryValidLabel;

@property (nonatomic, strong) IBOutlet AlertTableView *alertTable;

- (IBAction)updateAlertType:(id)sender;
- (IBAction)updateAlertName:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;
- (IBAction)addButtonPressed:(id)sender;
- (IBAction)deleteButtonPressed:(id)sender;
- (IBAction)testButtonPressed:(id)sender;


@end
