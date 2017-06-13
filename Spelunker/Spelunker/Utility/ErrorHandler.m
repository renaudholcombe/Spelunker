//
//  ErrorHandler.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/12/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "ErrorHandler.h"

@implementation ErrorHandler

+(void)PostError: (ErrorMessage *)errorMessage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Error" object:errorMessage];
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
