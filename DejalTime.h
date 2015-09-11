//
//  DejalTime.h
//  Dejal Open Source
//
//  Created by David Sinclair on 2015-09-02.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
//
//  This class is useful to store a time without a date in represented objects.
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


@interface DejalTime : DejalObject

/**
 The hour of the receiver.
 
 @author DJS 2015-09.
 */

@property (nonatomic) NSInteger hour;

/**
 The minute of the receiver.
 
 @author DJS 2015-09.
 */

@property (nonatomic) NSInteger minute;

/**
 The second of the receiver.
 
 @author DJS 2015-09.
 */

@property (nonatomic) NSInteger second;

/**
 The name of the time zone of the receiver, or an empty string to represent UTC/GMT, or nil to represent the local time zone.
 
 @author DJS 2015-09.
 */

@property (nonatomic) NSString *timeZoneName;

/**
 The time zone of the receiver, or nil to represent the local time zone.
 
 @author DJS 2015-09.
 */

@property (nonatomic, strong) NSTimeZone *timeZone;

/**
 A date representation of the receiver, with the date components set to today, or a previously assigned date.
 
 @author DJS 2015-09.
 */

@property (nonatomic, strong) NSDate *date;

/**
 Convenience class method to create a new DejalTime instance with the specified date.
 
 @param date The date to use.
 @returns A new DejalTime instance.
 
 @author DJS 2015-09.
 */

+ (instancetype)timeWithDate:(NSDate *)date;

/**
 Convenience class method to create a new DejalTime instance with the specified time.  Uses the local time zone.
 
 @param hour The hour to use.
 @param minute The minute to use.
 @param second The second to use.
 @returns A new DejalTime instance.
 
 @author DJS 2015-09.
 */

+ (instancetype)timeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

/**
 Convenience class method to create a new DejalTime instance with the specified time.
 
 @param hour The hour to use.
 @param minute The minute to use.
 @param second The second to use.
 @param timeZoneName The name of the time zone to use, an empty string to represent UTC/GMT, or nil to represent the local time zone.
 @returns A new DejalTime instance.
 
 @author DJS 2015-09.
 */

+ (instancetype)timeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second timeZoneName:(NSString *)timeZoneName;

/**
 Returns today's date with the time compoennts set from the receiver.
 
 @author DJS 2015-09.
 */

- (NSDate *)dateBySettingTimeToday;

/**
 Returns a date with the time components set from the receiver.
 
 @param date A date to use.
 @returns The date with the time components changed.
 
 @author DJS 2015-09.
 */

- (NSDate *)dateBySettingTimeWithDate:(NSDate *)date;

/**
 A string representation of the receiver, mainly for debugging.
 
 @author DJS 2015-09.
 */

- (NSString *)descriptionWithShortTime;

@end

