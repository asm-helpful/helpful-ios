//
//  HFConversation.h
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HFAccount;

/// Represents a conversation.
@interface HFConversation : NSObject

/// The unqiue ID.
@property (nonatomic, copy) NSString *conversationID;

/// The subject. Optional.
@property (nonatomic, copy) NSString *subject;

/// The date the conversation was created.
@property (nonatomic, strong) NSDate *created;

/// The date the conversation was updated.
@property (nonatomic, strong) NSDate *updated;

// A set of tags. Optional.
// TODO: implement this!
@property (nonatomic, copy) NSSet *tags;

// An array of messages. Always contains at least one message.
@property (nonatomic, copy) NSArray *messages;

// TODO: what's the purpose of this?
@property (nonatomic, strong) NSNumber *number;

@end


@interface HFConversation (RestKitAdditions)

/// Returns the RestKit mapping.
+ (RKObjectMapping *)objectMapping;

/// Returns an operation that can be used to fetch all conversations for a given account.
+ (RKObjectRequestOperation *)fetchConversationsRequestOperationForAccount:(HFAccount *)account;

@end
