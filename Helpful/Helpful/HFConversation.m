//
//  HFConversation.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFConversation.h"
#import "HFMessage.h"

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
        [mapping addAttributeMappingsFromDictionary:@{@"id": @"conversationID",
                                                      @"subject": @"subject",
                                                      @"created": @"created",
                                                      @"updated": @"updated"}];
        
        // Add message relationship mapping.
        RKObjectMapping *messageMapping = [HFMessage objectMapping];
        RKRelationshipMapping *messagesRelationship = [RKRelationshipMapping relationshipMappingFromKeyPath:@"messages" toKeyPath:@"messages" withMapping:messageMapping];
        [mapping addPropertyMapping:messagesRelationship];
        
        // TODO: map tags
    });
    return mapping;
}

@end
