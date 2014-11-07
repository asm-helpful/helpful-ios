//
//  HFMessage.h
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HFConversation, HFPerson;

/// Represents a message in a conversation.
@interface HFMessage : NSObject

/// The unique ID.
@property (nonatomic, copy) NSString *messageID;

/// The unique ID of the conversation this message is part of.
@property (nonatomic, copy) NSString *conversationID;

/// The person that created that message.
@property (nonatomic, strong) HFPerson *person;

/// The body of the message.
@property (nonatomic, copy) NSString *body;

/// The date the message was created.
@property (nonatomic, strong) NSDate *created;

/// THe date the messages was updated.
@property (nonatomic, strong) NSDate *updated;

@end


@interface HFMessage (RestKitAdditions)

/// Returns the RestKit mapping.
+ (RKObjectMapping *)objectMapping;

+ (RKObjectRequestOperation *)fetchMessageRequestOperationForConversation:(HFConversation *)conversation;

@end
