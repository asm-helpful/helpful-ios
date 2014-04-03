//
//  HFAccount.m
//  Helpful
//
//  Created by Matthias Plappert on 28/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFAccount.h"

@implementation HFAccount

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p accountID:%@ name:%@ slug:%@ created:%@ updated:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.accountID, self.name, self.slug, self.created, self.updated];
}

#pragma mark - RestKit Additions

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        NSDictionary *dict = @{@"id": HFTypedKeyPath(HFAccount, accountID),
                               @"name": HFTypedKeyPath(HFAccount, name),
                               @"slug": HFTypedKeyPath(HFAccount, slug),
                               @"created": HFTypedKeyPath(HFAccount, created),
                               @"updated": HFTypedKeyPath(HFAccount, updated)};
        [mapping addAttributeMappingsFromDictionary:dict];
    });
    return mapping;
}

+ (RKObjectRequestOperation *)fetchAccountsRequestOperation {
    static NSString *collectionKeyPath = @"accounts";
    static NSString *requestPath = @"/api/accounts";
    
    RKObjectMapping *mapping = [self objectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:collectionKeyPath statusCodes:nil];
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:requestPath parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    return operation;
}

@end
