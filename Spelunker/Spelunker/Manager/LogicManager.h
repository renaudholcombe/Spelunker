//
//  LogicManager.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogicManager : NSObject

+(id)sharedManager;

-(NSArray *) getAlertList;

@end
