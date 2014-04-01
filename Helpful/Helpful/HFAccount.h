//
//  HFAccount.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

/// Represents an account. A user can have multiple accounts.
@interface HFAccount : NSObject

/// The unique ID.
@property (nonatomic, copy) NSString *accountID;

/// The name.
@property (nonatomic, copy) NSString *name;

/// The URL slug.
@property (nonatomic, copy) NSString *slug;

/// The date the account was created.
@property (nonatomic, strong) NSDate *created;

/// The date the account was updated.
@property (nonatomic, strong) NSDate *updated;

@end


@interface HFAccount (RestKitAdditions)

/// Returns the RestKit mapping.
+ (RKObjectMapping *)objectMapping;

/// Returns an operation that can be used to fetch all accounts of the currently
/// logged in user.
+ (RKObjectRequestOperation *)fetchAccountsRequestOperation;

@end
