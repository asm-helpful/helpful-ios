//
//  HFConversation.h
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/*"created": "2014-03-06T19:17:30Z",
 "updated": "2014-03-06T19 :19:47Z",
 "id": "51ee56a7-f57a-4694-b0e8-ef0f058682bf",
 "type": "conversation",
 "number": 1,
 "subject": "Email seems to be down",
 "tags": [],
 "messages": [*/

@class HFAccount;

@interface HFConversation : NSObject

@property (nonatomic, copy) NSString *conversationID;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;
@property (nonatomic, copy) NSSet *tags;
@property (nonatomic, copy) NSArray *messages;

// TODO: what's the purpose of this?
@property (nonatomic, strong) NSNumber *number;

@end


@interface HFConversation (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;
+ (RKObjectRequestOperation *)fetchConversationsRequestOperationForAccount:(HFAccount *)account;

@end
