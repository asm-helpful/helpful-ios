//
//  HFAssignee.h
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HFPerson;

@interface HFAssignee : NSObject

@property (nonatomic, copy) NSString *assigneeID;

/// The date the assignee was created.
@property (nonatomic, strong) NSDate *created;

/// The date the assignee was updated.
@property (nonatomic, strong) NSDate *updated;

/// The person that was assigned to.
@property (nonatomic, strong) HFPerson *person;

@end

@interface HFAssignee (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;

@end
