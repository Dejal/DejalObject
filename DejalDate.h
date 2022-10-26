//
//  DejalDate.h
//  Dejal Open Source
//
//  Created by David Sinclair on 2015-02-16.
//  Copyright (c) 2015-2022 Dejal Systems, LLC. All rights reserved.
//
//  This class is useful to store dates in represented objects, including automatic
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


@interface DejalDate : DejalObject

/**
 Property for the OS data representation of the receiver.
 
 @author DJS 2015-02.
 */

@property (nonatomic, strong) NSDate *date;

/**
 Property for the string representation of the receiver.
 
 @author DJS 2015-02.
 */

@property (nonatomic, strong) NSString *string;

/**
 Property for the time interval since now of the receiver.  If the receiver is earlier than the current date & time, the result is negative.
 
 @author DJS 2015-02.
 */

@property (nonatomic) NSTimeInterval timeIntervalSinceNow;

/**
 Returns whether or not the date is today.
 */

@property (nonatomic, readonly) BOOL isToday;

/**
 Convenience class method to create a new DejalDate instance with the specified OS date.
 
 @param date The date to use.
 @returns A new DejalDate instance.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDate:(NSDate *)date;

/**
 Convenience class method to create a new DejalDate instance with the current date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithNow NS_SWIFT_NAME(now());

/**
 Convenience class method to create a new DejalDate instance with the distant past date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDistantPast NS_SWIFT_NAME(distantPast());

/**
 Convenience class method to create a new DejalDate instance with the distant future date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDistantFuture NS_SWIFT_NAME(distantFuture());

/**
 Adds a number of seconds to the receiver.
 
 @author DJS 2015-08.
 */

- (void)addTimeInterval:(NSTimeInterval)timeInterval;

- (NSString *)descriptionWithShortDateTime;

@end

