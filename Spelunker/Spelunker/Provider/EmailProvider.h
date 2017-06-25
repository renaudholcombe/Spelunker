//
//  EmailProvider.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Settings.h"

@interface EmailProvider : NSObject

+(id) sharedProvider;

-(void) sendTestEmail: (Settings *)settings;

@end
