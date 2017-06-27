//
//  UITextViewLogger.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/26/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextViewLogger : DDAbstractLogger <DDLogger> {
    NSMutableArray *logMsgCache;
    NSObject <DDLogFormatter> *internalFormatter;
}

@property (nonatomic, weak) NSTextView *textView;

-(id)initWithLogFormatter: (NSObject<DDLogFormatter> *)formatter;

@end
