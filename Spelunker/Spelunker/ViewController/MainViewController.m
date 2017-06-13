//
//  MainViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize alertNameTextField, scheduledRadio, pollingRadio, scheduledDatePicker, tableScrollView, addAlertButton, deleteAlertButton, saveAlertButton, alertSearchTextField, queryValidLabel, testAlertButton;

@synthesize alertTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.alertTable setDelegate:self];
    [self.alertTable setDataSource:self];
    logicManager = [LogicManager sharedManager];

    //notifications!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlertList:) name:@"ReloadAlerts" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSelectedAlert:) name:@"SwitchAlert" object:nil];
    [self changeControlState:NO];
}

#pragma mark tableview delegate methods

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
//    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    Alert *alert = [alertList objectAtIndex:row];
    //cellView.textField.stringValue = alert.alertName;
//    [cellView.textField setStringValue:alert.alertName];
    return alert.alertName;

}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return alertList.count;
}

-(void) tableViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"selected row = %ld", (long) [notification.object selectedRow]);
    NSInteger selectedRow = [notification.object selectedRow];
    if(selectedRow == -1 || selectedRow > alertList.count)
    {
        [self changeControlState:NO];
        return;
    }

    Alert *alert = [alertList objectAtIndex:[notification.object selectedRow]];
    tempAlertId = alert.alertId;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"SwitchAlert" object:alert];
}

#pragma mark datasource delegate methods

-(void) setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

#pragma mark notification methods

-(void) updateAlertList:(NSNotification *)notification
{
    alertList = notification.object;
    [alertTable reloadData];
}

-(void)switchSelectedAlert: (NSNotification *)notification
{
    [self changeControlState:YES];
    [self updateAlertControls:notification.object];
}

#pragma mark utility methods

-(void)updateAlertControls: (Alert *)alert
{
    alertNameTextField.stringValue = alert.alertName;
    queryValidLabel.stringValue = @"";

    if(alert.alertType == Polling){
        pollingRadio.state = 1;
        scheduledDatePicker.hidden = YES;
    }
    else {
        scheduledRadio.state = 1;
        scheduledDatePicker.hidden = NO;
        scheduledDatePicker.dateValue = (alert.scheduleTime == nil)? [NSDate date]: alert.scheduleTime;

    }

    saveAlertButton.enabled = NO;
    alertSearchTextField.stringValue = alert.searchString;
}

-(void)alertChanged
{
    if(tempAlertId != nil)
        saveAlertButton.enabled = YES;
//    else
//        [self changeControlState:NO];
}

-(void)changeControlState: (BOOL) value
{
    alertNameTextField.stringValue = @"";
    alertNameTextField.enabled = value;
    scheduledRadio.enabled = value;
    scheduledRadio.state = !value;
    pollingRadio.state = value;
    pollingRadio.enabled = value;
    scheduledDatePicker.hidden = !value;
    alertSearchTextField.stringValue = @"";
    alertSearchTextField.enabled = value;
    testAlertButton.enabled = value;
}

#pragma mark action methods

- (IBAction)updateAlertName:(id)sender {
    [self alertChanged];
}

- (IBAction)saveButtonPressed:(id)sender {
    //do save stuff
    Alert *currentAlert = alertList[[alertTable selectedRow]];
    currentAlert.alertName = alertNameTextField.stringValue;
    currentAlert.alertType = (pollingRadio.state)? Polling : Scheduled;
    currentAlert.scheduleTime = scheduledDatePicker.dateValue;
    currentAlert.searchString = alertSearchTextField.stringValue;
    [logicManager saveAlertList:alertList];

    tempAlertId = nil;
}

- (IBAction)addButtonPressed:(id)sender {
    Alert *tempAlert = [[Alert alloc] init];
    [tempAlert SetDefaults];
    tempAlertId = tempAlert.alertId;

    [alertList addObject:tempAlert];
    [alertTable reloadData];

    NSIndexSet *indexSet  = [NSIndexSet indexSetWithIndex:(alertList.count - 1)];
    [alertTable selectRowIndexes:indexSet byExtendingSelection:NO];

}

- (IBAction)deleteButtonPressed:(id)sender {
}

- (IBAction)testButtonPressed:(id)sender {
}

- (IBAction)updateAlertType:(id)sender {

    Alert *currentAlert = alertList[[alertTable selectedRow]];

    if([[sender identifier]  isEqual: @"AlertTypePolling"]){
        pollingRadio.state = 1;
        scheduledDatePicker.hidden = YES;
    }
    else if([[sender identifier]  isEqual: @"AlertTypeScheduled"]){
        scheduledRadio.state = 1;
        scheduledDatePicker.hidden = NO;
        scheduledDatePicker.dateValue = (currentAlert.scheduleTime == nil)? [NSDate date]: currentAlert.scheduleTime;
    }

    [self alertChanged];
}

@end
