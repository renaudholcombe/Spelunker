//
//  AlertProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "DataProvider.h"
#import "Alert.h"
#import "ErrorHandler.h"

@implementation DataProvider

NSString * const ALERTKEY = @"Alerts";

+ (id)sharedProvider
{
    static DataProvider *alertProvider = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertProvider = [[DataProvider alloc] init];
    });
    return alertProvider;
}

-(id) init
{
    self = [super init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

-(void)saveAlerts:(NSArray *)alerts
{
    AlertList *list = [[AlertList alloc] init];
    list.alertList = [[NSArray <Alert> alloc] initWithArray:alerts];


    NSString *jsonString = [list toJSONString];
    [userDefaults setObject:jsonString forKey:ALERTKEY];
}

-(NSArray *) getAlerts
{
    NSString *alertsString = [userDefaults objectForKey:ALERTKEY];
    if(alertsString == nil)
        return [[NSArray alloc] init];

    NSError *error = nil;
    AlertList *alertList = [[AlertList alloc] initWithString:alertsString error:&error];

    if(error != nil)
    {
        [ErrorHandler PostError:[[ErrorMessage alloc] initWithMessage:@"Error retrieving alerts." withError:error]];

        return [[NSArray alloc] init];
    }

    return alertList.alertList;
}

@end
