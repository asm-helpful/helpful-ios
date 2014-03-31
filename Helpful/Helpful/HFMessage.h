//
//  HFMessage.h
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/*
 {
 "created": "2014-03-06T19:18:52Z",
 "updated": "2014-03-06T19:18:52Z",
 "id": "ee21d726-f46d-45f3-b39c-c3d9ab87c078",
 "type": "message",
 "body": "I tried to send you an email a few minutes ago, but I received a delivery notification saying your email address doesn't exist.",
 "conversation_id": "51ee56a7-f57a-4694-b0e8-ef0f058682bf",
 "person_id":"3ad45600-b8d5-42da-b43e-d837d8d67ab9"
 }
 */

@class HFConversation, HFPerson;

@interface HFMessage : NSObject

@property (nonatomic, copy) NSString *messageID;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, weak) HFConversation *conversation;
@property (nonatomic, strong) HFPerson *person;

@end


@interface HFMessage (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;

@end
