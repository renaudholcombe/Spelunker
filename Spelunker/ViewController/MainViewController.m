//
//  MainViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "AlertHandler.h"


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize alertNameTextField, scheduledRadio, pollingRadio, scheduledDatePicker, tableScrollView, addAlertButton, deleteAlertButton, saveAlertButton, alertSearchTextField, testAlertButton, scheduledInterval;

@synthesize alertTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.alertTable setDelegate:self];
    [self.alertTable setDataSource:self];

    //notifications!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlertList:) name:@"ReloadAlerts" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSelectedAlert:) name:@"SwitchAlert" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openPreferencesPane) name:@"OpenPreferences" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadManagers:) name:@"Load managers" object:nil];

    [self changeControlState:NO];
}

-(void) loadManagers: (NSNotification *)notification
{
    logicManager = [LogicManager sharedManager];
}


-(void) openPreferencesPane
{

    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
    NSViewController *preferences = [storyboard instantiateControllerWithIdentifier:@"PreferencesViewController"];

    [self presentViewControllerAsSheet:preferences];
}


#pragma mark tableview delegate methods

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    Alert *alert = [alertList objectAtIndex:row];
    return alert.alertName;

}

-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView
{
    return alertList.count;
}

-(void) tableViewSelectionDidChange:(NSNotification *)notification
{
    NSInteger selectedRow = [notification.object selectedRow];
    if(selectedRow == -1 || selectedRow > alertList.count)
    {
        [self changeControlState:NO];
        return;
    }

    Alert *alert = [alertList objectAtIndex:[notification.object selectedRow]];
    DDLogDebug(@"Selected alert: %@", alert.alertName);
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
    alertList =[[NSMutableArray alloc] initWithArray: notification.object];
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

    if(alert.alertType == Polling){
        pollingRadio.state = 1;
        scheduledDatePicker.hidden = YES;
        scheduledInterval.hidden = YES;
    }
    else {
        scheduledRadio.state = 1;
        scheduledDatePicker.hidden = NO;
        scheduledDatePicker.dateValue = (alert.scheduleTime == nil)? [NSDate date]: alert.scheduleTime;

        scheduledInterval.hidden = NO;
        if(alert.schedulerTimeInterval == 24 || alert.schedulerTimeInterval == 0)
            scheduledInterval.stringValue = @"";
        else
            scheduledInterval.integerValue = alert.schedulerTimeInterval;
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
    scheduledInterval.hidden = !value;
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
    currentAlert.schedulerTimeInterval = scheduledInterval.integerValue;
    currentAlert.searchString = alertSearchTextField.stringValue;
    [logicManager saveAlert:currentAlert];

    saveAlertButton.enabled = NO;
    NSInteger currentRow = [alertTable selectedRow];
    [alertTable reloadData];

    NSIndexSet *indexSet  = [NSIndexSet indexSetWithIndex:currentRow];
    [alertTable selectRowIndexes:indexSet byExtendingSelection:NO];
}

- (IBAction)addButtonPressed:(id)sender {
    Alert *tempAlert = [[Alert alloc] init];
    tempAlertId = tempAlert.alertId;

    [alertList addObject:tempAlert];
    [alertTable reloadData];

    NSIndexSet *indexSet  = [NSIndexSet indexSetWithIndex:(alertList.count - 1)];
    [alertTable selectRowIndexes:indexSet byExtendingSelection:NO];

}

- (IBAction)deleteButtonPressed:(id)sender {
}

- (IBAction)testButtonPressed:(id)sender {

    Alert *currentAlert = alertList[[alertTable selectedRow]];
    currentAlert.alertName = alertNameTextField.stringValue;
    currentAlert.alertType = (pollingRadio.state)? Polling : Scheduled;
    currentAlert.scheduleTime = scheduledDatePicker.dateValue;
    currentAlert.schedulerTimeInterval = scheduledInterval.integerValue;
    currentAlert.searchString = alertSearchTextField.stringValue;

    [AlertHandler showAlert:@"Query is being tested. You should receive an email to the configured address. Check the Log Viewer in case of any errors."];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"Fire alert" object:currentAlert];
}

- (IBAction)updateAlertType:(id)sender {

    Alert *currentAlert = alertList[[alertTable selectedRow]];

    if([[sender identifier]  isEqual: @"AlertTypePolling"]){
        pollingRadio.state = 1;
        scheduledDatePicker.hidden = YES;
        scheduledInterval.hidden = YES;
    }
    else if([[sender identifier]  isEqual: @"AlertTypeScheduled"]){
        scheduledRadio.state = 1;
        scheduledDatePicker.hidden = NO;
        scheduledDatePicker.dateValue = (currentAlert.scheduleTime == nil)? [NSDate date]: currentAlert.scheduleTime;

        scheduledInterval.hidden = NO;
        if(currentAlert.schedulerTimeInterval == 24 || currentAlert.schedulerTimeInterval == 0)
            scheduledInterval.stringValue = @"";
        else
            scheduledInterval.integerValue = currentAlert.schedulerTimeInterval;

    }

    [self alertChanged];
}

@end
