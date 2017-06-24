//
//  JSONValueTransformer+NSUUID.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/23/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "JSONValueTransformer+NSUUID.h"

@implementation JSONValueTransformer (NSUUID)

-(NSUUID *) NSUUIDFromNSString:(NSString *)string
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:string];
    return uuid;
}

-(NSString *)JSONObjectFromNSUUID:(NSUUID *)uuid
{
    return [uuid UUIDString];
}

@end
