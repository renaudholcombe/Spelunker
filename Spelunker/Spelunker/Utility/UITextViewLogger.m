//
//  UITextViewLogger.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//


#import "UITextViewLogger.h"
@import AppKit;

@implementation UITextViewLogger

@synthesize textView;

-(id)initWithLogFormatter: (NSObject<DDLogFormatter> *)formatter
{
    self = [super init];
    logMsgCache = [[NSMutableArray alloc] init];
    internalFormatter = formatter; //don't ask about this hack
    return self;
}

-(void) appendTextStorageString:(DDLogMessage *) message
{
    NSAssert(textView != nil, @"textView is nil in logger");

    dispatch_async(dispatch_get_main_queue(), ^(void){

        [textView.textStorage appendAttributedString:[self getAttributedString:message]];
        [textView scrollRangeToVisible:NSMakeRange(textView.textStorage.length, 0)];
    });
}

-(NSAttributedString *)getAttributedString:(DDLogMessage *)message
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[internalFormatter formatLogMessage:message]];
    switch(message.flag) {
        case DDLogFlagError:
            [string addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, string.length)];
            break;
        case DDLogFlagWarning:
            [string addAttribute:NSForegroundColorAttributeName value:[NSColor orangeColor] range:NSMakeRange(0, string.length)];
            break;
        case DDLogFlagDebug:
            [string addAttribute:NSForegroundColorAttributeName value:[NSColor grayColor] range:NSMakeRange(0, string.length)];
            break;
        default:
            break;
    }

    return string;
}

-(void) setTextView:(NSTextView *)newTextView
{
    textView = newTextView;
    //NSArray *flushedCache = [[NSArray alloc] initWithArray:logMsgCache];
    //[logMsgCache removeAllObjects];

    for (DDLogMessage *message in logMsgCache) {
        [self appendTextStorageString:message];
    }
}

-(void)flushLogCache
{
    [logMsgCache removeAllObjects];
    [textView setString:@""];
}


#pragma mark Logger methods

-(void)logMessage:(DDLogMessage *)logMessage
{
    if(textView)
    {
        [self appendTextStorageString:logMessage];
    } else
    {
        [logMsgCache addObject:logMessage];
        if(logMsgCache.count > 100) //this application is meant for longterm use, make sure we don't steal all the resources.
            [logMsgCache removeObjectAtIndex:0];
    }
}


@end
