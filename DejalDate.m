//
//  DejalDate.m
//  Dejal Open Source
//
//  Created by David Sinclair on 2015-02-16.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
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

#import "DejalDate.h"


NSUInteger const DejalDateVersion = 1;

NSString * const DejalDateKeyString = @"string";


@interface DejalDate ()

@property (nonatomic, strong) NSDate *cachedDate;
@property (nonatomic, strong) NSString *cachedString;

@end


@implementation DejalDate

/**
 Convenience class method to create a new DejalDate instance with the specified OS date.
 
 @param date The date to use.
 @returns A new DejalDate instance.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDate:(NSDate *)date;
{
    DejalDate *obj = [self new];
    
    obj.date = date;
    
    return obj;
}

/**
 Convenience class method to create a new DejalDate instance with the current date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithNow;
{
    return [self dateWithDate:[NSDate date]];
}

/**
 Convenience class method to create a new DejalDate instance with the distant past date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDistantPast;
{
    return [self dateWithDate:[NSDate distantPast]];
}

/**
 Convenience class method to create a new DejalDate instance with the distant future date.
 
 @author DJS 2014-02.
 */

+ (instancetype)dateWithDistantFuture;
{
    return [self dateWithDate:[NSDate distantFuture]];
}

/**
 Initializer from a coder.  Supports secure coding.
 
 @param decoder The coder to use.
 @returns The initialized instance.
 
 @author DJS 2015-02.
 */

- (instancetype)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]))
    {
        self.string = [decoder decodeObjectOfClass:[NSString class] forKey:DejalDateKeyString];
    }
    
    return self;
}

/**
 Encodes the receiver.
 
 @param encoder The coder to use.
 
 @author DJS 2015-02.
 */

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.string forKey:DejalDateKeyString];
}

/**
 Indicates that this class supports secure coding (needed for XPC).
 
 @author DJS 2015-02.
 */

+ (BOOL)supportsSecureCoding;
{
    return YES;
}

/**
 Populates the receiver's properties with default values.
 
 @author DJS 2015-02.
 */

- (void)loadDefaultValues;
{
    [super loadDefaultValues];
    
    self.version = DejalDateVersion;
    self.date = nil;
}

/**
 Singleton to return a date formatter for the RFC3339 standard internet date format.
 
 @author DJS 2012-04.
 @version DJS 2015-02: Copied from NSDate+Dejal (in DejalFoundationCategories).
 */

+ (NSDateFormatter *)internetDateFormatter;
{
    static NSDateFormatter *internetDateFormatter = nil;
    
    if (!internetDateFormatter)
    {
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        internetDateFormatter = [NSDateFormatter new];
        
        [internetDateFormatter setLocale:enUSPOSIXLocale];
        [internetDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [internetDateFormatter setTimeZone:[NSTimeZone defaultTimeZone]];
        [internetDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    }
    
    return internetDateFormatter;
}

/**
 Returns the OS date for the receiver.
 
 @author DJS 2015-02.
 */

- (NSDate *)date;
{
    if (!self.cachedDate && self.cachedString.length)
    {
        NSString *jsonDate = self.cachedString;
        
        if ([jsonDate hasPrefix:@"1899-12-30"] || [jsonDate hasPrefix:@"0001-01-01"])
        {
            self.cachedDate = nil;
        }
        else
        {
            NSRange position = [jsonDate rangeOfString:@"."];
            
            if (position.location != NSNotFound)
            {
                jsonDate = [jsonDate substringToIndex:position.location];
            }
            
            if (![jsonDate hasSuffix:@"Z"])
            {
                jsonDate = [jsonDate stringByAppendingString:@"Z"];
            }
            
            self.cachedDate = [[DejalDate internetDateFormatter] dateFromString:jsonDate];
        }
    }
    
    return self.cachedDate;
}

/**
 Sets the receiver to the specified OS date.
 
 @author DJS 2015-02.
 */

- (void)setDate:(NSDate *)date;
{
    [self willChangeValueForKey:@"date"];
    [self willChangeValueForKey:@"string"];
    
    self.cachedDate = date;
    self.cachedString = nil;
    
    [self didChangeValueForKey:@"date"];
    [self didChangeValueForKey:@"string"];
}

/**
 Returns a string representation of the receiver.
 
 @author DJS 2015-02.
 */

- (NSString *)string;
{
    if (!self.cachedString && self.cachedDate)
    {
        self.cachedString = [[DejalDate internetDateFormatter] stringFromDate:self.cachedDate];
    }
    
    return self.cachedString;
}

/**
 Sets the receiver to the date represented by the string.
 
 @author DJS 2015-02.
 */

- (void)setString:(NSString *)string;
{
    [self willChangeValueForKey:@"date"];
    [self willChangeValueForKey:@"string"];
    
    self.cachedDate = nil;
    self.cachedString = string;
    
    [self didChangeValueForKey:@"date"];
    [self didChangeValueForKey:@"string"];
}

/**
 Returns the time interval since now of the receiver.  If the receiver is earlier than the current date & time, the result is negative.
 
 @author DJS 2015-02.
 */

- (NSTimeInterval)timeIntervalSinceNow;
{
    return [self.date timeIntervalSinceNow];
}

/**
 Sets the receiver to the date the specified number of seconds from the current date & time.
 
 @author DJS 2015-02.
 */

- (void)setTimeIntervalSinceNow:(NSTimeInterval)timeIntervalSinceNow;
{
    self.date = [NSDate dateWithTimeIntervalSinceNow:timeIntervalSinceNow];
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-02.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DejalDateKeyString]];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: %@ ('%@')", [self className], self.descriptionWithShortDateTime, self.string];
}

- (NSString *)descriptionWithShortDateTime;
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return [dateFormatter stringFromDate:self.date];
}

@end

