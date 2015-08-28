//
//  DejalData.h
//  Dejal Open Source
//
//  Created by David Sinclair on 2015-08-27.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
//
//  This class is useful to store data in represented objects, including automatic
//  dictionary or JSON encoding.
//
//  Redistribution and use in source and binary forms, with or without modification,
//  are permitted provided that the following conditions are met:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
//  - Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "DejalObject.h"


@interface DejalData : DejalObject

/**
 Property for the OS data representation of the receiver.
 
 @author DJS 2015-08.
 */

@property (nonatomic, strong) NSData *data;

/**
 Property for the Base-64, UTF-8 encoded string representation of the receiver.
 
 @author DJS 2015-08.
 */

@property (nonatomic, strong) NSString *string;

/**
 Property for an arbitrary object representation of the receiver.  It is automatically archived into the data.
 
 @author DJS 2015-08.
 */

@property (nonatomic, strong) id object;

/**
 Read-only property; returns YES if the receiver's data is nil.  Doesn't trigger Base-64 encoding or decoding.
 
 @author DJS 2015-08.
 */

@property (nonatomic, readonly, getter=isEmpty) BOOL empty;

/**
 Property for the length of the OS data representation of the receiver.  Don't set this; it's just settable for KVC purposes.
 
 @author DJS 2015-08.
 */

@property (nonatomic) NSUInteger length;

/**
 Convenience class method to create a new DejalData instance with nil data.
 
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)data;

/**
 Convenience class method to create a new DejalData instance with the specified OS data.
 
 @param data The data to use.
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)dataWithData:(NSData *)data;

/**
 Convenience class method to create a new DejalData instance with the specified arbitrary object.
 
 @param object The object to use.
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)dataWithObject:(id)object;

@end

