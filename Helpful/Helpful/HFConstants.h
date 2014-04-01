//
//  HFConstants.h
//  Helpful
//
//  Created by Matthias Plappert on 01/04/14.
//  Copyright (c) 2014 Helpful. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The base URL used for API requests.
extern NSString *const HFBaseURLString;

/**
 * Provides the ability to verify key paths at compile time.
 *
 * If "keyPath" does not exist, a compile-time error will be generated.
 */
#define HFKeyPath(object, keyPath) ({ if (NO) { (void)((object).keyPath); } @#keyPath; })
#define HFSelfKeyPath(keyPath) HFKeyPath(self, keyPath)
#define HFTypedKeyPath(ObjectClass, keyPath) HFKeyPath(((ObjectClass *)nil), keyPath)
#define HFProtocolKeyPath(Protocol, keyPath) HFKeyPath(((id <Protocol>)nil), keyPath)
