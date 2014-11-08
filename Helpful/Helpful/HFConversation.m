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
#import "HFTagEvent.h"
#import "HFAssignmentEvent.h"

#import "NSNumber+HFAdditions.h"

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
        
        // Add tagEvent mapping.
        RKObjectMapping *tagEventMapping = [HFTagEvent objectMapping];
        RKRelationshipMapping *tagEventRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"tag_events" toKeyPath:HFTypedKeyPath(HFConversation, tagEvents) withMapping:tagEventMapping];
        [mapping addPropertyMapping:tagEventRelationship];

        RKObjectMapping *assignmentEventMapping = [HFAssignmentEvent objectMapping];
        RKRelationshipMapping *assignmentEventRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"assignment_events" toKeyPath:HFTypedKeyPath(HFConversation, assignmentEvents) withMapping:assignmentEventMapping];
        [mapping addPropertyMapping:assignmentEventRelationship];

    });
    return mapping;
}

+ (RKObjectRequestOperation *)fetchConversationsRequestOperationForAccount:(HFAccount *)account archived:(NSNumber *)archived {
    NSParameterAssert(account);
    
    static NSString *collectionKeyPath = @"conversations";
    NSString *requestPath = [NSString stringWithFormat:@"/api/accounts/%@/conversations", account.accountID ];
    NSDictionary *params = nil;
    if (archived) {
        params = @{@"archived": [archived hf_boolStringValue]};
    }
    
    RKObjectMapping *mapping = [self objectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:collectionKeyPath statusCodes:nil];
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:requestPath parameters:params];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    return operation;
}

+ (RKObjectRequestOperation *)fetchAllConversationsRequestOperationForAccount:(HFAccount *)account {
    return [self fetchConversationsRequestOperationForAccount:account archived:nil];
}

+ (RKObjectRequestOperation *)fetchArchivedConversationsRequestOperationForAccount:(HFAccount *)account {
    return [self fetchConversationsRequestOperationForAccount:account archived:@(YES)];
}

+ (RKObjectRequestOperation *)fetchInboxConversationsRequestOperationForAccount:(HFAccount *)account {
    return [self fetchConversationsRequestOperationForAccount:account archived:@(NO)];
}

@end
