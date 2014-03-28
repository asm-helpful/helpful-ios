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
    static NSString *format = @"<%@: %p accountID:%@ name:%@ slug:%@ createdAt:%@ updatedAt:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.accountID, self.name, self.slug, self.createdAt, self.updatedAt];
}

#pragma mark - RestKit Additions

+ (RKObjectMapping *)objectMapping {
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:self];
    [mapping addAttributeMappingsFromDictionary:@{@"id": @"accountID",
                                                  @"name": @"name",
                                                  @"slug": @"slug",
                                                  @"created": @"createdAt",
                                                  @"updated": @"updatedAt"}];
    return mapping;
}

+ (RKObjectRequestOperation *)accountsRequestOperation {
    RKObjectMapping *mapping = [self objectMapping];
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodGET pathPattern:nil keyPath:@"accounts" statusCodes:nil];
    NSURLRequest *request = [[RKObjectManager sharedManager] requestWithObject:nil method:RKRequestMethodGET path:@"/api/accounts" parameters:nil];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    return operation;
}

@end
