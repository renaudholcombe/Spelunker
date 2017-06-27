//
//  SpelunkerLogFormatter.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "SpelunkerLogFormatter.h"

@implementation SpelunkerLogFormatter

-(NSString *) formatLogMessage:(DDLogMessage *)logMessage
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];

    NSString *logTime = [dateFormatter stringFromDate:[NSDate date]];

    NSString *logLevel;
    switch(logMessage.flag){
        case DDLogFlagInfo : logLevel = @"INFO"; break;
        case DDLogFlagDebug : logLevel = @"DEBUG"; break;
        case DDLogFlagWarning : logLevel=@"WARNING"; break;
        case DDLogFlagError : logLevel=@"ERROR"; break;
        default : logLevel=@"VERBOSE"; break;
    }

    return [NSString stringWithFormat:@"%@ : %@ : %@ : %@\n", logTime, logLevel, logMessage.fileName, logMessage.message];
}

@end
