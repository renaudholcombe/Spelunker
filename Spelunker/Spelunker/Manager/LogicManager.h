//
//  LogicManager.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"

@interface LogicManager : NSObject
{
    DataProvider *dataProvider;
}

+(id)sharedManager;

-(void) getAlertList;
-(void) saveAlertList: (NSArray *) alertList;

@end
