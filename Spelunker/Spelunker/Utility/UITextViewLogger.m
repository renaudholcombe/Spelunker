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

-(void) appendTextStorageString:(NSString *) string
{
    NSAssert(textView != nil, @"textView is nil in logger");

    dispatch_async(dispatch_get_main_queue(), ^(void){

        [textView.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:string]];

        [textView scrollRangeToVisible:NSMakeRange(textView.textStorage.length, 0)];
    });
}

#pragma mark Logger methods

-(void)logMessage:(DDLogMessage *)logMessage
{
    NSString *logMsg;
//    DDAbstractLogger<DDLogger> *logFormatter = self.logFormatter;

    logMsg = [internalFormatter formatLogMessage:logMessage];

    if(textView)
    {
        [self appendTextStorageString:[NSString stringWithFormat:@"\n%@", logMsg]];
    } else
    {
        [logMsgCache addObject:logMsg];
    }
}

-(void) setTextView:(NSTextView *)newTextView
{
    textView = newTextView;
    NSString *fullLog = [logMsgCache componentsJoinedByString:@"\n"];
    [logMsgCache removeAllObjects];
    [self appendTextStorageString:fullLog];
}

@end
