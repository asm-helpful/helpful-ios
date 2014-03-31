//
//  HFAccount.h
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface HFAccount : NSObject

@property (nonatomic, copy) NSString *accountID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *slug;
@property (nonatomic, strong) NSDate *created;
@property (nonatomic, strong) NSDate *updated;

@end


@interface HFAccount (RestKitAdditions)

+ (RKObjectMapping *)objectMapping;
+ (RKObjectRequestOperation *)accountsRequestOperation;

@end
