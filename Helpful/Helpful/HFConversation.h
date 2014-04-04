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

/* Returns an operation that can be used to fetch all conversations for a given account.
 *
 * @param account The account that the conversations should be related to. Required.
 * @param archived Indicates if archived conversations (archived = `YES`), conversations that are
 * in your inbox (archived = `NO`), or all conversations (archived = `nil`) should be fetched. Optional.
 * @return The request operation
 */
+ (RKObjectRequestOperation *)fetchConversationsRequestOperationForAccount:(HFAccount *)account archived:(NSNumber *)archived;

/// Fetches all conversations, both archived and inbox ones.
+ (RKObjectRequestOperation *)fetchAllConversationsRequestOperationForAccount:(HFAccount *)account;

/// Fetches archived conversations.
+ (RKObjectRequestOperation *)fetchArchivedConversationsRequestOperationForAccount:(HFAccount *)account;

/// Fetches inbox conversations.
+ (RKObjectRequestOperation *)fetchInboxConversationsRequestOperationForAccount:(HFAccount *)account;

@end
