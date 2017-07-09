//
//  AlertProvider.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "DataProvider.h"
#import "Alert.h"
#import "AlertHandler.h"
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
NSString * const EMAIL_FROMADDRESSKEY = @"EmailFromAddress";
NSString * const EMAIL_USESSLKEY = @"EmailUseSSL";
NSString * const EMAIL_USERNAMEKEY = @"EmailUsername";
NSString * const EMAIL_PASSWORDKEY = @"EmailPassword";
NSString * const EMAIL_SERVICENAME = @"Spelunker_SMTP";
NSString * const EMAIL_PORTOVERRIDEKEY = @"EmailPortOverride";


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
    DDLogInfo(@"Initialized");
    return self;
}

#pragma mark alert methods

-(void)saveAlerts:(NSArray *)alerts
{
    AlertList *list = [[AlertList alloc] init];
    list.alertList = [[NSArray <Alert> alloc] initWithArray:alerts];


    NSString *jsonString = [list toJSONString];
    [userDefaults setObject:jsonString forKey:ALERTKEY];
    DDLogInfo(@"Alerts saved");
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
        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error retrieving alerts." withError:error]];

        return [[NSArray alloc] init];
    }

    DDLogInfo(@"Alerts loaded");
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
    settings.smtpFromAddress = [userDefaults objectForKey:EMAIL_FROMADDRESSKEY];
    settings.smtpUseSSL = [[userDefaults objectForKey:EMAIL_USESSLKEY] boolValue];
    settings.smtpUsername = [userDefaults objectForKey:EMAIL_USERNAMEKEY];
    settings.smtpPortOverride = [[userDefaults objectForKey:EMAIL_PORTOVERRIDEKEY] integerValue];

    //keychain stuff
    NSError *error = nil;
    settings.splunkPassword = [self getPasswordfor:@"Spelunker" withAccount:[NSString stringWithFormat:@"Splunk_%@", settings.splunkUsername] withError:&error];

    settings.smtpPassword = [self getPasswordfor:@"Spelunker" withAccount:[NSString stringWithFormat:@"SMTP_%@", settings.smtpUsername] withError:&error];

    if (error != nil)
    {
        settings.splunkPassword = @"";
        settings.smtpPassword = @"";
        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error loading passwords!" withError:error]];
    }
    DDLogInfo(@"Settings loaded");
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
    [settingDict setObject:settings.smtpFromAddress forKey:EMAIL_FROMADDRESSKEY];
    [settingDict setObject:settings.smtpUsername forKey:EMAIL_USERNAMEKEY];
    [settingDict setObject:[[NSNumber alloc] initWithBool:settings.smtpUseSSL] forKey:EMAIL_USESSLKEY];
    [settingDict setObject:[[NSNumber alloc] initWithInteger:settings.smtpPortOverride] forKey:EMAIL_PORTOVERRIDEKEY];

    [userDefaults setValuesForKeysWithDictionary:settingDict];

    NSError *error = nil;

    [self setPassword:settings.splunkPassword For:@"Spelunker" withAccount:[NSString stringWithFormat:@"Splunk_%@", settings.splunkUsername] withError:&error];

    if(error != nil)
    {
        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error saving passwords!" withError:error]];
        return;
    }


    [self setPassword:settings.smtpPassword For:@"Spelunker" withAccount:[NSString stringWithFormat:@"SMTP_%@", settings.smtpUsername] withError:&error];

    if(error != nil)
    {
        [AlertHandler postError:[[ErrorMessage alloc] initWithMessage:@"Error saving passwords!" withError:error]];
    }

    DDLogInfo(@"Settings saved");
}

-(NSString *) getPasswordfor: (NSString *)service withAccount: (NSString *)account withError:(NSError **) error
{
    NSString *password = @"";


    if(account == nil)
        return @"";

    NSArray *accountArray = [account componentsSeparatedByString:@"_"];
    if(accountArray.count != 2 || [accountArray[1] isEqualToString:@""])
        return @"";

/*    NSArray *accounts = [SAMKeychain accountsForService:service error:error];
    if(accounts == nil)
        return @"";
*/


    password = [SAMKeychain passwordForService:service account:account error:error];

    return (password == nil) ? @"": password;
}

//The return value is to avoid a pointless analyzer warning
-(id) setPassword: (NSString *) password For: (NSString *)service withAccount: (NSString *)account withError:(NSError **)error
{
    if(account == nil || [account isEqualToString:@""])
        return nil;

    [SAMKeychain setPassword:password forService:service account:account error:error];

    return nil;
}

@end
