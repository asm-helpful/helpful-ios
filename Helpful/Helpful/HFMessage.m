//
//  HFMessage.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessage.h"

@implementation HFMessage

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p messageID:%@ body:%@ created:%@ updated:%@ conversationID:%@ personID:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.messageID, self.body, self.created, self.updated, self.conversationID, self.personID];
}

#pragma mark - RestKit Additions

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFMessage, messageID),
                               @"body": HFTypedKeyPath(HFMessage, body),
                               @"created": HFTypedKeyPath(HFMessage, created),
                               @"updated": HFTypedKeyPath(HFMessage, updated),
                               @"conversation_id": HFTypedKeyPath(HFMessage, conversationID),
                               @"person_id": HFTypedKeyPath(HFMessage, personID)};
        [mapping addAttributeMappingsFromDictionary:dict];
    });
    return mapping;
}

@end
