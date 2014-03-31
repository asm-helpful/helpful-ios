//
//  HFMessage.m
//  Helpful
//
//  Created by Matthias Plappert on 31/03/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import "HFMessage.h"

@implementation HFMessage

#pragma mark - NSObject

- (NSString *)description {
    static NSString *format = @"<%@: %p messageID:%@ body:%@ created:%@ updated:%@ conversation:%@>";
    return [NSString stringWithFormat:format, NSStringFromClass(self.class), self, self.messageID, self.body, self.created, self.updated, self.conversation];
}

#pragma mark - RestKit Additions

+ (RKObjectMapping *)objectMapping {
    static RKObjectMapping *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [RKObjectMapping mappingForClass:self];
        [mapping addAttributeMappingsFromDictionary:@{@"id": @"messageID",
                                                      @"subject": @"body",
                                                      @"created": @"created",
                                                      @"updated": @"updated"}];
        
        // TODO: figure out how to do reverse stuff and how to extract the person id
    });
    return mapping;
}

@end
