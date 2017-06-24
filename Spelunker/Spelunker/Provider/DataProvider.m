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
#import "SAMKeychain.h"

@implementation DataProvider

//constants
NSString * const ALERTKEY = @"Alerts";
NSString * const SPLUNK_ADDRESSKEY = @"SplunkAddress";
NSString * const SPLUNK_PORTOVERRIDEKEY = @"SplunkPortOverride";
NSString * const SPLUNK_USERNAMEKEY = @"SplunkUsername";
NSString * const SPLUNK_PASSWORDKEY = @"SplunkPassword";
NSString * const SPLUNK_SERVICENAME = @"Spelunker_Splunk";

NSString * const EMAIL_SERVERKEY = @"EmailServer";
NSString * const EMAIL_ADDRESSKEY = @"EmailAddress";
NSString * const EMAIL_USESSLKEY = @"EmailUseSSL";
NSString * const EMAIL_USERNAMEKEY = @"EmailUsername";
NSString * const EMAIL_PASSWORDKEY = @"EmailPassword";
NSString * const EMAIL_SERVICENAME = @"Spelunker_SMTP";


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

#pragma mark alert methods

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

#pragma mark settings methods

-(Settings *) getSettings
{
    //userdefaults stuff
    Settings *settings = [[Settings alloc] init];
    settings.splunkServer = [userDefaults objectForKey:SPLUNK_ADDRESSKEY];
    settings.splunkPortOverride = [[userDefaults objectForKey:SPLUNK_PORTOVERRIDEKEY] integerValue];
    settings.splunkUsername = [userDefaults objectForKey:SPLUNK_USERNAMEKEY];

    settings.smtpServer = [userDefaults objectForKey:EMAIL_SERVERKEY];
    settings.smtpEmailAddress = [userDefaults objectForKey:EMAIL_ADDRESSKEY];
    settings.smtpUseSSL = [[userDefaults objectForKey:EMAIL_USESSLKEY] boolValue];
    settings.smtpUsername = [userDefaults objectForKey:EMAIL_USERNAMEKEY];

    //keychain stuff
    NSError *error = nil;
    settings.splunkPassword = [self getPasswordfor:SPLUNK_SERVICENAME withAccount:settings.splunkUsername withError:&error];

    settings.smtpPassword = [self getPasswordfor:EMAIL_SERVICENAME withAccount:settings.smtpUsername withError:&error];

    if (error != nil)
    {
        settings.splunkPassword = @"";
        settings.smtpPassword = @"";
        [ErrorHandler PostError:[[ErrorMessage alloc] initWithMessage:@"Error loading passwords!" withError:error]];
    }

    return settings;
}

-(void) saveSettings:(Settings *)settings
{
    NSMutableDictionary *settingDict = [[NSMutableDictionary alloc] init];

    [settingDict setObject:settings.splunkUsername forKey:SPLUNK_USERNAMEKEY];
    [settingDict setObject:[[NSNumber alloc] initWithInteger:settings.splunkPortOverride] forKey:SPLUNK_PORTOVERRIDEKEY];
    [settingDict setObject:settings.splunkServer forKey:SPLUNK_ADDRESSKEY];

    [settingDict setObject:settings.smtpServer forKey:EMAIL_SERVERKEY];
    [settingDict setObject:settings.smtpEmailAddress forKey:EMAIL_ADDRESSKEY];
    [settingDict setObject:settings.smtpUsername forKey:EMAIL_USERNAMEKEY];
    [settingDict setObject:[[NSNumber alloc] initWithBool:settings.smtpUseSSL] forKey:EMAIL_USESSLKEY];

    [userDefaults setValuesForKeysWithDictionary:settingDict];

    NSError *error = nil;

    [self setPassword:settings.splunkPassword For:SPLUNK_SERVICENAME withAccount:settings.splunkUsername withError:&error];
    [self setPassword:settings.smtpPassword For:EMAIL_SERVICENAME withAccount:settings.smtpUsername withError:&error];

    if(error != nil)
    {
        [ErrorHandler PostError:[[ErrorMessage alloc] initWithMessage:@"Error saving passwords!" withError:error]];
    }

}

-(NSString *) getPasswordfor: (NSString *)service withAccount: (NSString *)account withError:(NSError **) error
{
    NSString *password = @"";

    if(account == nil || [account isEqualToString:@""])
        return @"";

    @try {
    password = [SAMKeychain passwordForService:service account:account error:error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }

    return (password == nil) ? @"": password;
}

-(void) setPassword: (NSString *) password For: (NSString *)service withAccount: (NSString *)account withError:(NSError **)error
{
    if(account == nil || [account isEqualToString:@""])
        return;

    @try {
        [SAMKeychain setPassword:password forService:service account:account error:error];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }

    return;
}

@end
