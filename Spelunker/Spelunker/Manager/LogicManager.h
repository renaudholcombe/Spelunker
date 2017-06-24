//
//  LogicManager.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataProvider.h"
#import "Alert.h"

@interface LogicManager : NSObject
{
    DataProvider *dataProvider;
    NSMutableDictionary *alertDictionary;
}

+(id)sharedManager;

-(void) getAlertList;
-(void) saveAlert: (Alert *)alert;

@end
