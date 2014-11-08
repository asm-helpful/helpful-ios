//
//  HFAssignmentEvent.h
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HFPerson;
@class HFAssignee;

@interface HFAssignmentEvent : NSObject

/// The unique ID.
@property (nonatomic, copy) NSString *assignmentEventID;

/// The date the tag event was created.
@property (nonatomic, strong) NSDate *created;

/// The date the tag event was updated.
@property (nonatomic, strong) NSDate *updated;

/// The assignee.
@property (nonatomic, strong) HFAssignee *assignee;

/// The person that created that message.
@property (nonatomic, strong) HFPerson *person;


@end

@interface HFAssignmentEvent (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;

@end
