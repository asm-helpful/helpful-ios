//
//  NSNumber+HFAdditions.h
//  Helpful
//
//  Created by Matthias Plappert on 04/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (HFAdditions)

/// Returns `@"true"` or `@"false"` depending on the value.
- (NSString *)hf_boolStringValue;

@end
