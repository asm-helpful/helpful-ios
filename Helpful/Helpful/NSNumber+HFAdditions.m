//
//  NSNumber+HFAdditions.m
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "NSNumber+HFAdditions.h"

@implementation NSNumber (HFAdditions)

- (NSString *)hf_boolStringValue {
    BOOL value = [self boolValue];
    return value ? @"true" : @"false";
}

@end
