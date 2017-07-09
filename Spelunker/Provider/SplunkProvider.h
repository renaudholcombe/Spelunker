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
#import "Constants.h"

@interface SplunkProvider : NSObject {
    NSURLSessionConfiguration *sessionConfiguration;
    NSURLSession *session;
    Settings *settings;
    NSOperationQueue *jobOperationQueue;
    NSDictionary *searchJobStatus;
}

+(id) sharedProvider;

-(void) testConnection: (Settings *)testSettings;

-(void) searchSplunk:(Alert *) alert;

@end

