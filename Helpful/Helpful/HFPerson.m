//
//  HFPerson.m
//  Helpful
//
//  Created by Jeroen Leenarts on 04-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFPerson.h"

@implementation HFPerson

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFPerson, personID),
                               @"name": HFTypedKeyPath(HFPerson, name),
                               @"nickname": HFTypedKeyPath(HFPerson, nickname),
                               @"created": HFTypedKeyPath(HFPerson, created),
                               @"updated": HFTypedKeyPath(HFPerson, updated),
                               @"initials": HFTypedKeyPath(HFPerson, initials),
                               @"gravatar_url": HFTypedKeyPath(HFPerson, gravatarUrl),
                               @"email": HFTypedKeyPath(HFPerson, email)};
        [mapping addAttributeMappingsFromDictionary:dict];
    });
    return mapping;
}

@end
