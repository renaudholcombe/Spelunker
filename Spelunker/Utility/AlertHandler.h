//
//  AlertHandler.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/12/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSError *error;

-(id) initWithMessage: (NSString *)message withError:(NSError *)error;

@end

@interface AlertHandler : NSObject

+(void)postError: (ErrorMessage *)errorMessage;
+(void)showAlert: (NSString *)message;

@end

