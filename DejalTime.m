//
//  DejalTime.m
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

#import "DejalTime.h"


NSUInteger const DejalTimeVersion = 1;

NSString * const DejalTimeKeyHour = @"hour";
NSString * const DejalTimeKeyMinute = @"minute";
NSString * const DejalTimeKeySecond = @"second";
NSString * const DejalTimeKeyTimeZoneName = @"timeZoneName";


@interface DejalTime ()

@property (nonatomic, strong) NSTimeZone *cachedTimeZone;
@property (nonatomic, strong) NSDate *cachedDate;

@end


@implementation DejalTime

/**
 Convenience class method to create a new DejalTime instance with the specified date.
 
 @param date The date to use.
 @returns A new DejalTime instance.
 
 @author DJS 2015-09.
 */

+ (instancetype)timeWithDate:(NSDate *)date;
{
    DejalTime *obj = [self new];
    
    obj.date = date;
    
    return obj;
}

/**
 Convenience class method to create a new DejalTime instance with the specified time.  Uses the local time zone.
 
 @param hour The hour to use.
 @param minute The minute to use.
 @param second The second to use.
 @returns A new DejalTime instance.
 
 @author DJS 2015-09.
 */

+ (instancetype)timeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
{
    return [self timeWithHour:hour minute:minute second:second timeZoneName:nil];
}

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
{
    DejalTime *obj = [self new];
    
    obj.cachedDate = nil;
    obj.hour = hour;
    obj.minute = minute;
    obj.second = second;
    obj.timeZoneName = timeZoneName;
    
    return obj;
}

/**
 Initializer from a coder.  Supports secure coding.
 
 @param decoder The coder to use.
 @returns The initialized instance.
 
 @author DJS 2015-09.
 */

- (instancetype)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]))
    {
        self.hour = [decoder decodeIntegerForKey:DejalTimeKeyHour];
        self.minute = [decoder decodeIntegerForKey:DejalTimeKeyMinute];
        self.second = [decoder decodeIntegerForKey:DejalTimeKeySecond];
        self.timeZoneName = [decoder decodeObjectOfClass:[NSString class] forKey:DejalTimeKeyTimeZoneName];
    }
    
    return self;
}

/**
 Encodes the receiver.
 
 @param encoder The coder to use.
 
 @author DJS 2015-09.
 */

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeInteger:self.hour forKey:DejalTimeKeyHour];
    [encoder encodeInteger:self.minute forKey:DejalTimeKeyMinute];
    [encoder encodeInteger:self.second forKey:DejalTimeKeySecond];
    [encoder encodeObject:self.timeZoneName forKey:DejalTimeKeyTimeZoneName];
}

/**
 Indicates that this class supports secure coding (needed for XPC).
 
 @author DJS 2015-09.
 */

+ (BOOL)supportsSecureCoding;
{
    return YES;
}

/**
 Populates the receiver's properties with default values.
 
 @author DJS 2015-09.
 */

- (void)loadDefaultValues;
{
    [super loadDefaultValues];
    
    self.version = DejalTimeVersion;
    self.hour = 12;
    self.minute = 0;
    self.second = 0;
    self.timeZoneName = nil;
}

/**
 Property getter for the time zone of the receiver, or nil to represent the local time zone.
 
 @author DJS 2015-09.
 */

- (NSTimeZone *)timeZone;
{
    if (!self.cachedTimeZone)
    {
        if (!self.timeZoneName)
        {
            self.cachedTimeZone = nil;
        }
        else if (self.timeZoneName.length)
        {
            self.cachedTimeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        }
        else
        {
            self.cachedTimeZone = [NSTimeZone timeZoneWithName:self.timeZoneName];
        }
    }
    
    return self.cachedTimeZone;
}

/**
 Property setter for the time zone of the receiver; pass nil to represent the local time zone.
 
 @author DJS 2015-09.
 */

- (void)setTimeZone:(NSTimeZone *)timeZone;
{
    if ([timeZone.name isEqualToString:@"GMT"])
    {
        self.timeZoneName = @"";
    }
    else
    {
        self.timeZoneName = timeZone.name;
    }
}

/**
 Property getter for a date representation of the receiver, with the date components set to today, or a previously assigned date.
 
 @author DJS 2015-09.
 */

- (NSDate *)date;
{
    if (!self.cachedDate)
    {
        self.cachedDate = [self dateBySettingTimeWithDate:[NSDate date]];
    }
    
    return self.cachedDate;
}

/**
 Property setter from a date representation of the receiver.
 
 @author DJS 2015-09.
 */

- (void)setDate:(NSDate *)date;
{
    if ([date isEqualToDate:self.cachedDate])
    {
        return;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:date];
    
    self.hour = components.hour;
    self.minute = components.minute;
    self.second = components.second;
    
    // Have to set this after the above, as setting them clears this:
    self.cachedDate = date;
}

/**
 Returns a date with the time components set from the receiver.
 
 @param date A date to use.
 @returns The date with the time components changed.
 
 @author DJS 2015-09.
 */

- (NSDate *)dateBySettingTimeWithDate:(NSDate *)date;
{
    return [[NSCalendar currentCalendar] dateBySettingHour:self.hour minute:self.minute second:self.second ofDate:date options:0];
}

/**
 Key-Value Observing method when one of the saved properties of the receiver changes.
 
 @author DJS 2015-09.
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if ([keyPath isEqualToString:DejalTimeKeyHour] || [keyPath isEqualToString:DejalTimeKeyMinute] || [keyPath isEqualToString:DejalTimeKeySecond] || [keyPath isEqualToString:DejalTimeKeyTimeZoneName])
    {
        self.cachedDate = nil;
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-09.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DejalTimeKeyHour, DejalTimeKeyMinute, DejalTimeKeySecond, DejalTimeKeyTimeZoneName]];
}

/**
 A string representation of the receiver, including the class name, for debugging.
 
 @author DJS 2015-09.
 */

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: %@", [self className], self.descriptionWithShortTime];
}

/**
 A string representation of the receiver, mainly for debugging.
 
 @author DJS 2015-09.
 */

- (NSString *)descriptionWithShortTime;
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateStyle = NSDateFormatterNoStyle;
    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeZone = self.timeZone;
    
    return [dateFormatter stringFromDate:self.date];
}

@end

