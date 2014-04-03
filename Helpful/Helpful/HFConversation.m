//
//  HFConversation.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversation.h"
#import "HFMessage.h"
#import "HFAccount.h"

@implementation HFConversation

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p conversationID:%@ subject:%@ created:%@ updated:%@ tags:%@ messages:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.conversationID, self.subject, self.created, self.updated, self.tags, self.messages];
}

#pragma mark - RestKit Additions

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFConversation, conversationID),
                               @"subject": HFTypedKeyPath(HFConversation, subject),
                               @"created": HFTypedKeyPath(HFConversation, created),
                               @"updated": HFTypedKeyPath(HFConversation, updated),
                               @"number": HFTypedKeyPath(HFConversation, number)};
        [mapping addAttributeMappingsFromDictionary:dict];
        
        // Add message relationship mapping.
        RKObjectMapping *messageMapping = [HFMessage objectMapping];
        RKRelationshipMapping *messagesRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"messages" toKeyPath:HFTypedKeyPath(HFConversation, messages) withMapping:messageMapping];
        [mapping addPropertyMapping:messagesRelationship];
        
        // TODO: map tags
    });
    return mapping;
}

+ (RKObjectRequestOperation *)fetchConversationsRequestOperationForAccount:(HFAccount *)account {
    static NSString *collectionKeyPath = @"conversations";
    static NSString *requestPath = @"/api/conversations";
    NSDictionary *params = @{@"account": account.accountID};
    
    RKObjectMapping *mapping = [self objectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:collectionKeyPath statusCodes:nil];
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:requestPath parameters:params];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    return operation;
}

@end
