//
//  HFPerson.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFPerson.h"

@implementation HFPerson

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p personID:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.personID];
}

@end
