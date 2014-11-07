//
//  HFMessage.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessage.h"
#import "HFPerson.h"
#import "HFConversation.h"

@implementation HFMessage

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p messageID:%@ body:%@ created:%@ updated:%@ conversationID:%@ personID:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.messageID, self.body, self.created, self.updated, self.conversationID, self.person.personID];
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
                               @"conversation_id": HFTypedKeyPath(HFMessage, conversationID)};
        [mapping addAttributeMappingsFromDictionary:dict];
        [mapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"person"
                                                                                       toKeyPath:@"person"
                                                                                     withMapping:[HFPerson objectMapping]]];
    });
    return mapping;
}

+ (RKObjectRequestOperation *)fetchMessageRequestOperationForConversation:(HFConversation *)conversation {
    NSParameterAssert(conversation);

    static NSString *collectionKeyPath = @"messages";
    NSString *requestPath = [NSString stringWithFormat:@"/api/conversations/%@/messages", conversation.conversationID];

    RKObjectMapping *mapping = [self objectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:collectionKeyPath statusCodes:nil];
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:requestPath parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    return operation;
}

@end
