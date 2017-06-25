//
//  AlertHandler.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/12/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "AlertHandler.h"
#import <Cocoa/Cocoa.h>

@implementation AlertHandler

+(void)postError: (ErrorMessage *)errorMessage
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = errorMessage.message;
    alert.informativeText = [NSString stringWithFormat:@"%@", errorMessage.error];
    [alert addButtonWithTitle:@"Ok"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [alert runModal];
    });

}

+(void)showAlert:(NSString *)message
{
    NSAlert *alert = [[NSAlert alloc] init];
    alert.messageText = message;
    [alert addButtonWithTitle:@"Ok"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [alert runModal];
    });

}


@end

@implementation ErrorMessage

-(id) initWithMessage:(NSString *)message withError:(NSError *)error
{
    self = [super init];
    _message = message;
    _error = error;

    return self;
}

@end
