//
//  HFTagEvent.h
//  Helpful
//
//  Created by Jeroen Leenarts on 08-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@class HFPerson;

@interface HFTagEvent : NSObject

/// The unique ID.
@property (nonatomic, copy) NSString *tagEventID;

/// The date the tag event was created.
@property (nonatomic, strong) NSDate *created;

/// The date the tag event was updated.
@property (nonatomic, strong) NSDate *updated;

/// The tag.
@property (nonatomic, copy) NSString *tagName;

/// The person that created that message.
@property (nonatomic, strong) HFPerson *person;

@end

@interface HFTagEvent (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;

@end

