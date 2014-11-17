//
//  HFAssignee.m
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFAssignee.h"
#import "HFPerson.h"

@implementation HFAssignee

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFAssignee, assigneeID),
                               @"created": HFTypedKeyPath(HFAssignee, created),
                               @"updated": HFTypedKeyPath(HFAssignee, updated)};
        [mapping addAttributeMappingsFromDictionary:dict];
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"person"
                                                                                toKeyPath:@"person"
                                                                              withMapping:[HFPerson objectMapping]]];
    });
    return mapping;
}

@end
