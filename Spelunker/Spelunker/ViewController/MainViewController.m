//
//  MainViewController.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "MainViewController.h"
#import "Alert.h"
#import "Constants.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize alertNameTextField, scheduledRadio, pollingRadio, scheduledDatePicker, tableScrollView, addAlertButton, deleteAlertButton, saveAlertButton, alertSearchTextField, queryValidLabel;

@synthesize alertTable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.alertTable setDelegate:self];
    [self.alertTable setDataSource:self];

    //notifications!
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAlertList:) name:@"ReloadAlerts" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchSelectedAlert:) name:@"SwitchAlert" object:nil];
}

#pragma mark tableview delegate methods

/*-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *cellView = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    Alert *alert = [alertList objectAtIndex:row];
    //cellView.textField.stringValue = alert.alertName;
    [cellView.textField setStringValue:alert.alertName];
    return cellView;
}*/

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
    if([notification.object selectedRow] > alertList.count)
        return;
    Alert *alert = [alertList objectAtIndex:[notification.object selectedRow]];
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
    alertList = [notification object];
    [alertTable reloadData];
}

-(void)switchSelectedAlert: (NSNotification *)notification
{
    [self updateAlertControls:notification.object];
}

#pragma mark utility methods

-(void)updateAlertControls: (Alert *)alert
{
    alertNameTextField.stringValue = alert.alertName;

    if(alert.alertType == Polling){
        pollingRadio.state = 1;
        scheduledDatePicker.hidden = YES;
    }
    else {
        scheduledRadio.state = 1;
        scheduledDatePicker.hidden = NO;
        scheduledDatePicker.dateValue = (alert.scheduleTime == nil)? [NSDate date]: alert.scheduleTime;

    }

    saveAlertButton.enabled = false;
    alertSearchTextField.stringValue = alert.searchString;
}

-(void)alertChanged
{
    saveAlertButton.enabled = YES;
}

#pragma mark action methods

- (IBAction)updateAlertName:(id)sender {
    [self alertChanged];
}

- (IBAction)saveButtonPressed:(id)sender {
}

- (IBAction)addButtonPressed:(id)sender {
}

- (IBAction)deleteButtonPressed:(id)sender {
}

- (IBAction)testButtonPressed:(id)sender {
}

- (IBAction)updateAlertType:(id)sender {
    [self alertChanged];
}

@end
