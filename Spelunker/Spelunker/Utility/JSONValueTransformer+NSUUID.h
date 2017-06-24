//
//  JSONValueTransformer+NSUUID.h
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

@import Foundation;
#import "JSONModel/JSONModel.h"

@interface JSONValueTransformer (NSUUID)

-(NSUUID *)NSUUIDFromNSString:(NSString *)string;
-(NSString *)JSONObjectFromNSUUID:(NSUUID *)uuid;


@end
