//
//  HFPerson.h
//  Helpful
//
//  Created by Jeroen Leenarts on 04-11-14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HFPerson : NSObject

/// The unique ID.
@property (nonatomic, copy) NSString *personID;

/// The person's email.
@property (nonatomic, copy) NSString *email;

/// The person's gravatar's URL.
@property (nonatomic, copy) NSString *gravatarUrl;

/// The name.
@property (nonatomic, copy) NSString *name;

/// The nickname.
@property (nonatomic, copy) NSString *nickname;

/// The initials.
@property (nonatomic, copy) NSString *initials;

/// The date the person was created.
@property (nonatomic, strong) NSDate *created;

/// The date the person was updated.
@property (nonatomic, strong) NSDate *updated;

@end


@interface HFPerson (RestKitAdditions)


+ (RKObjectMapping *)objectMapping;

@end
