//
//  HFTagEvent.m
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFTagEvent.h"
#import "HFPerson.h"

@implementation HFTagEvent

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFTagEvent, tagEventID),
                               @"created": HFTypedKeyPath(HFTagEvent, created),
                               @"updated": HFTypedKeyPath(HFTagEvent, updated),
                               @"tag": HFTypedKeyPath(HFTagEvent, tagName)};
        [mapping addAttributeMappingsFromDictionary:dict];
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                toKeyPath:@"person"
                                                                              withMapping:[HFPerson objectMapping]]];

    });
    return mapping;
}

@end
