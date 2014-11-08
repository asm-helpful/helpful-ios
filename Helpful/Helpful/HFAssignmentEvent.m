//
//  HFAssignmentEvent.m
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFAssignmentEvent.h"
#import "HFAssignee.h"
#import "HFPerson.h"

@implementation HFAssignmentEvent

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFAssignmentEvent, assignmentEventID),
                               @"created": HFTypedKeyPath(HFAssignmentEvent, created),
                               @"updated": HFTypedKeyPath(HFAssignmentEvent, updated)};
        [mapping addAttributeMappingsFromDictionary:dict];
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                toKeyPath:@"person"
                                                                              withMapping:[HFPerson objectMapping]]];
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"assignee"
                                                                                toKeyPath:@"assignee"
                                                                              withMapping:[HFAssignee objectMapping]]];

        
    });
    return mapping;
}

@end
