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
                               @"email": HFTypedKeyPath(HFPerson, email)};
        [mapping addAttributeMappingsFromDictionary:dict];
    });
    return mapping;
}

@end

/*
 "person":{"created":"2014-10-30T22:40:03Z","updated":"2014-10-30T22:40:03Z","id":"dc6dc75c-816d-4a11-b794-44f4cccb9bad","type":"person","email":"patrick@mail.helpful.io","gravatar_url":"https://secure.gravatar.com/avatar/65f1eebcc1666a692131742678eee279.png?s=60\u0026d=mm","initials":"PV","name":"Patrick Van Stee","nickname":"Patrick Van Stee","agent":false},"attachments":[]}]}
*/