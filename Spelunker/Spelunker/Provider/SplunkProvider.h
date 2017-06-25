//
//  SplunkProvider.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface SplunkProvider : NSObject {
    NSURLSessionConfiguration *sessionConfiguration;
    NSURLSession *session;
}

+(id) sharedProvider;

-(void) testConnection: (Settings *)settings;

@end
