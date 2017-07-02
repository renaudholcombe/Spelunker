//
//  SplunkProvider.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"
#import "Alert.h"

@interface SplunkProvider : NSObject {
    NSURLSessionConfiguration *sessionConfiguration;
    NSURLSession *session;
    Settings *settings;
    NSOperationQueue *jobCheckQueue;

}

+(id) sharedProvider;

-(void) testConnection: (Settings *)testSettings;

-(void) searchSplunk:(Alert *) alert isTest: (BOOL) isTest;

@end

