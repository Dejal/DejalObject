//
//  DejalInterval.m
//  Dejal Open Source
//
//  Created by David Sinclair on 2007-04-05.
//  Copyright (c) 2007-2015 Dejal Systems, LLC. All rights reserved.
//
//  This class encapsulates a time interval or range, and is useful to store them
//  in represented objects, including automatic dictionary or JSON encoding.
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

#import "DejalInterval.h"


NSUInteger const DejalIntervalVersion = 1;

NSString * const DejalIntervalKeyUsingRange = @"usingRange";
NSString * const DejalIntervalKeyFirstAmount = @"firstAmount";
NSString * const DejalIntervalKeySecondAmount = @"secondAmount";
NSString * const DejalIntervalKeyUnits = @"units";
NSString * const DejalIntervalKeyExtraValues = @"extraValues";


@implementation DejalInterval

/**
 Convenience class method to return a new DejalInterval with the specified amount and units.
 
 @author DJS 2007-04.
 @version DJS 2008-07: Changed to support ranges.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2011-02: Changed to remove the old mode parameter.
 @version DJS 2011-10: Changed to support ARC.
*/

+ (instancetype)intervalWithAmount:(NSInteger)amount units:(DejalIntervalUnits)aUnits;
{
    return [[self alloc] initWithRange:NO firstAmount:amount secondAmount:amount units:aUnits];
}

/**
 Convenience class method to return a new DejalInterval with the specified range of amounts and units.
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2011-02: Changed to remove the old mode parameter.
 @version DJS 2011-10: Changed to support ARC.
*/

+ (instancetype)intervalWithRangeFirstAmount:(NSInteger)aFirstAmount secondAmount:(NSInteger)aSecondAmount units:(DejalIntervalUnits)aUnits;
{
    return [[self alloc] initWithRange:YES firstAmount:aFirstAmount secondAmount:aSecondAmount units:aUnits];
}

/**
 Convenience class method to return a new DejalInterval with the amount, units, and extra values specified in the dictionary representation (as returned by -dictionary).
 
 @author DJS 2007-04.
 @version DJS 2008-07: Changed to support ranges.
 @version DJS 2010-05: Changed to use the "Amount" value if there is no "SecondAmount", for legacy data support (needed when loading Simon data from before 2.6).
 @version DJS 2011-02: Changed to use lowercase-prefixed values if available, as per my new convention (better for KVC), and support extra values.
 @version DJS 2011-10: Changed to support ARC, and to avoid using my NSDictionary categories, to make more portable.
 @version DJS 2014-01: Changed to split the class and init methods.
*/

+ (instancetype)intervalWithDictionary:(NSDictionary *)dict;
{
    return [[self alloc] initWithDictionary:dict];
}

/**
 Designated initializer.
 
 @author DJS 2007-04.
 @version DJS 2008-07: Changed to use properties and support ranges.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2011-02: Changed to remove the old mode parameter, and add extraValues.
*/

- (instancetype)initWithRange:(BOOL)wantRange firstAmount:(NSInteger)aFirstAmount secondAmount:(NSInteger)aSecondAmount units:(DejalIntervalUnits)aUnits;
{
    if ((self = [self init]))
    {
        self.usingRange = wantRange;
        self.firstAmount = aFirstAmount;
        self.secondAmount = aSecondAmount;
        self.units = aUnits;
        self.extraValues = nil;
    }
    
    return self;
}

/**
 NSCoding protocol method; returns an object initialized via the specified unarchiver.
 
 @author DJS 2011-02.
 @version DJS 2014-01: Changed to support secure coding.
*/

- (instancetype)initWithCoder:(NSCoder *)coder;
{
    if ((self = [super initWithCoder:coder]))
    {
        self.usingRange = [coder decodeBoolForKey:DejalIntervalKeyUsingRange];
        self.firstAmount = [coder decodeIntegerForKey:DejalIntervalKeyFirstAmount];
        self.secondAmount = [coder decodeIntegerForKey:DejalIntervalKeySecondAmount];
        self.units = (DejalIntervalUnits)[coder decodeIntegerForKey:DejalIntervalKeyUnits];
        self.extraValues = [[coder decodeObjectOfClasses:[NSSet setWithObject:[NSObject class]] forKey:DejalIntervalKeyExtraValues] mutableCopy];
    }
    
    return self;
}

/**
 NSCoding protocol method; encodes the receiver using the specified archiver.
 
 @author DJS 2011-02.
 @version DJS 2015-04: Added missing super call.
*/

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [super encodeWithCoder:coder];
    
    [coder encodeBool:self.usingRange forKey:DejalIntervalKeyUsingRange];
    [coder encodeInteger:self.firstAmount forKey:DejalIntervalKeyFirstAmount];
    [coder encodeInteger:self.secondAmount forKey:DejalIntervalKeySecondAmount];
    [coder encodeInteger:self.units forKey:DejalIntervalKeyUnits];
    [coder encodeObject:self.extraValues forKey:DejalIntervalKeyExtraValues];
}

/**
 Indicates that this class supports secure coding (needed for XPC).
 
 @author DJS 2014-01.
 */

+ (BOOL)supportsSecureCoding;
{
    return YES;
}

/**
 NSCopying protocol method; returns a new copy of the receiver.
 
 @author DJS 2007-07.
 @version DJS 2008-07: Changed to use properties and support ranges.
 @version DJS 2011-02: Changed to add the extraValues property.
 @version DJS 2011-10: Changed to support ARC.
 @version DJS 2015-02: Changed to inherit from DejalRepresentedObject.
*/

- (instancetype)copyWithZone:(NSZone *)zone;
{
    DejalInterval *interval = [super copyWithZone:zone];
    
    interval.extraValues = [self.extraValues mutableCopy];
    
    return interval;
}

/**
 Returns the value for the specified key.  This enables retrieving any aribitrary value from the receiver, e.g. via [interval valueForKey:@"foo"].
 
 @author DJS 2011-02.
*/

- (id)valueForUndefinedKey:(NSString *)key;
{
    return [self.extraValues valueForKey:key];
}

/**
 Sets the value for the specified key.  This enables storing any aribitrary value in the receiver, e.g. via [interval setValue:@"bar" forKey:@"foo"].
 
 @author DJS 2011-02.
 @version DJS 2014-01: Changed to set hasChanges.
*/

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
{
    if (!self.extraValues)
    {
        self.extraValues = [NSMutableDictionary dictionary];
    }
    
    [self.extraValues setValue:value forKey:key];
    
    self.hasChanges = YES;
}

/**
 Populates the receiver's properties with default values.
 
 @author DJS 2015-02.
 */

- (void)loadDefaultValues;
{
    [super loadDefaultValues];
    
    self.version = DejalIntervalVersion;
    self.usingRange = NO;
    self.firstAmount = 30;
    self.secondAmount = 0;
    self.units = DejalIntervalUnitsMinute;
    self.extraValues = nil;
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-02.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DejalIntervalKeyUsingRange, DejalIntervalKeyFirstAmount, DejalIntervalKeySecondAmount, DejalIntervalKeyUnits, DejalIntervalKeyExtraValues]];
}

/**
 Returns a string that describes the contents of the receiver.
 
 @author DJS 2007-04.
 @version DJS 2008-07: Changed to use properties and support ranges.
*/

- (NSString *)description;
{
    if (self.usingRange)
    {
        return [NSString stringWithFormat:@"%@ = %.2f - %.2f seconds", self.amountWithFullUnitsName, self.firstTimeInterval, self.secondTimeInterval];
    }
    else
    {
        return [NSString stringWithFormat:@"%@ = %.2f seconds", self.amountWithFullUnitsName, self.amountTimeInterval];
    }
}

/**
 Populates the receiver's properties from the dictionary.
 
 @author DJS 2007-04.
 @version DJS 2008-07: Changed to support ranges.
 @version DJS 2010-05: Changed to use the "Amount" value if there is no "SecondAmount", for legacy data support (needed when loading Simon data from before 2.6).
 @version DJS 2011-02: Changed to use lowercase-prefixed values if available, as per my new convention (better for KVC), and support extra values.
 @version DJS 2011-10: Changed to support ARC, and to avoid using my NSDictionary categories, to make more portable.
 @version DJS 2014-01: Changed to split the class and init methods.
 @version DJS 2015-02: Changed from -initWithDictionary: to -setDictionary:.
 */

- (void)setDictionary:(NSDictionary *)dictionary;
{
    [super setDictionary:dictionary];
    
    NSDictionary *extra = dictionary[DejalIntervalKeyExtraValues];
    
    if (extra)
    {
        self.extraValues = [extra mutableCopy];
    }
}

/**
 Returns the receiver represented as a time interval, i.e. in seconds or fractions thereof.
 
 @author DJS 2008-07.
*/

- (NSTimeInterval)amountTimeInterval;
{
    return self.secondTimeInterval;
}

/**
 Returns the first amount of the receiver represented as a time interval, i.e. in seconds or fractions thereof.
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
*/

- (NSTimeInterval)firstTimeInterval;
{
    if (self.units == DejalIntervalUnitsNever)
    {
        return DejalIntervalAmountNever;
    }
    else if (self.units == DejalIntervalUnitsForever)
    {
        return DejalIntervalAmountForever;
    }
    else
    {
        return self.firstAmount * self.unitsTimeInterval;
    }
}

/**
 Returns the second amount of the receiver represented as a time interval, i.e. in seconds or fractions thereof.
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
*/

- (NSTimeInterval)secondTimeInterval;
{
    if (self.units == DejalIntervalUnitsNever)
    {
        return DejalIntervalAmountNever;
    }
    else if (self.units == DejalIntervalUnitsForever)
    {
        return DejalIntervalAmountForever;
    }
    else
    {
        return self.secondAmount * self.unitsTimeInterval;
    }
}

/**
 Returns the time difference between the first and second amounts, represented as a time interval, i.e. in seconds or fractions thereof.  The result is negative if the first amount is greater than the second one.
 
 @author DJS 2008-07.
*/

- (NSTimeInterval)rangeDifferenceInterval;
{
    return self.secondTimeInterval - self.firstTimeInterval;
}

/**
 Returns the units of the receiver represented as a time interval, i.e. in seconds or fractions thereof.  This value can be multiplied by the amounts.
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2012-01: Changed to use DejalIntervalAmount.
*/

- (NSTimeInterval)unitsTimeInterval;
{
    switch (self.units)
    {
        case DejalIntervalUnitsMinute:
            return DejalIntervalAmountMinute;
        case DejalIntervalUnitsHour:
            return DejalIntervalAmountHour;
        case DejalIntervalUnitsDay:
            return DejalIntervalAmountDay;
        case DejalIntervalUnitsWeek:
            return DejalIntervalAmountWeek;
        case DejalIntervalUnitsMonth:
            return DejalIntervalAmountMonth;
        case DejalIntervalUnitsYear:
            return DejalIntervalAmountYear;
        case DejalIntervalUnitsNever:
            return DejalIntervalAmountNever;
        case DejalIntervalUnitsForever:
            return DejalIntervalAmountForever;
        default:
            return DejalIntervalAmountSecond;
    }
}

/**
 Accessor for the amount property.  Returns the second amount; provided as a more intuitive property name when not using a range.
 
 @author DJS 2008-07.
*/

- (NSInteger)amount;
{
    return self.secondAmount;
}

/**
 Accessor for the amount property.  Sets both amounts; provided as a more intuitive property name when not using a range.
 
 @author DJS 2008-07.
*/

- (void)setAmount:(NSInteger)amount;
{
    self.firstAmount = amount;
    self.secondAmount = amount;
}

/**
 Returns a string with the amount and brief units name, e.g. "5 mins" or "1 wk".
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
*/

- (NSString *)amountWithBriefUnitsName;
{
    if (self.units == DejalIntervalUnitsNever || self.units == DejalIntervalUnitsForever)
    {
        return [self briefUnitsName];
    }
    
    if (self.usingRange)
    {
        return [NSString stringWithFormat:@"%ld - %ld %@", self.firstAmount, self.secondAmount, self.briefUnitsName];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld %@", self.secondAmount, self.briefUnitsName];
    }
}

/**
 Returns a string with the amount and full units name, e.g. "5 minutes" or "1 week".
 
 @author DJS 2008-07.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
*/

- (NSString *)amountWithFullUnitsName;
{
    if (self.units == DejalIntervalUnitsNever || self.units == DejalIntervalUnitsForever)
    {
        return [self fullUnitsName];
    }
    
    if (self.usingRange)
    {
        return [NSString stringWithFormat:@"%ld - %ld %@", self.firstAmount, self.secondAmount, self.fullUnitsName];
    }
    else
    {
        return [NSString stringWithFormat:@"%ld %@", self.secondAmount, self.fullUnitsName];
    }
}

/**
 Given an NSInteger value, if it is zero, the zero string is returned; if one, the singular string is returned; otherwise the plural string is returned.
 
 @author DJS around 2002 in the NSString categories; copied here in 2011-10.
*/

+ (NSString *)stringWithIntegerValue:(NSInteger)value singluar:(NSString *)singular plural:(NSString *)plural
{
    if (value == 1 && singular)
    {
        return singular;
    }
    else
    {
        return plural;
    }
}

/**
 Returns a brief localized string for the units of the receiver, using singular or plural as appropriate for the amount, e.g. "min" or "wks".
 
 @author DJS 2007-04.
 @version DJS 2007-07: Changed to add forever.
 @version DJS 2008-07: Changed to use properties.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2011-10: Changed to avoid using my NSDictionary categories, to make more portable.
*/

- (NSString *)briefUnitsName;
{
    if (self.secondAmount == 1)
    {
        switch (self.units)
        {
            case DejalIntervalUnitsMinute:
                return NSLocalizedStringFromTable(@"min", @"DejalInterval", @"minute singular");
            
            case DejalIntervalUnitsHour:
                return NSLocalizedStringFromTable(@"hr", @"DejalInterval", @"hour singular");
                
            case DejalIntervalUnitsDay:
                return NSLocalizedStringFromTable(@"day", @"DejalInterval", @"day singular");
                
            case DejalIntervalUnitsWeek:
                return NSLocalizedStringFromTable(@"wk", @"DejalInterval", @"week singular");
                
            case DejalIntervalUnitsMonth:
                return NSLocalizedStringFromTable(@"mth", @"DejalInterval", @"month singular");
                
            case DejalIntervalUnitsYear:
                return NSLocalizedStringFromTable(@"yr", @"DejalInterval", @"year singular");
                
            case DejalIntervalUnitsNever:
                return NSLocalizedStringFromTable(@"never", @"DejalInterval", @"never");
                
            case DejalIntervalUnitsForever:
                return NSLocalizedStringFromTable(@"forever", @"DejalInterval", @"forever");
                
            default:
                return NSLocalizedStringFromTable(@"sec", @"DejalInterval", @"second singular");
        }
    }
    else
    {
        switch (self.units)
        {
            case DejalIntervalUnitsMinute:
                return NSLocalizedStringFromTable(@"mins", @"DejalInterval", @"minute plural");
                
            case DejalIntervalUnitsHour:
                return NSLocalizedStringFromTable(@"hrs", @"DejalInterval", @"hour plural");
                
            case DejalIntervalUnitsDay:
                return NSLocalizedStringFromTable(@"days", @"DejalInterval", @"day plural");
                
            case DejalIntervalUnitsWeek:
                return NSLocalizedStringFromTable(@"wks", @"DejalInterval", @"week plural");
                
            case DejalIntervalUnitsMonth:
                return NSLocalizedStringFromTable(@"mths", @"DejalInterval", @"month plural");
                
            case DejalIntervalUnitsYear:
                return NSLocalizedStringFromTable(@"yrs", @"DejalInterval", @"year plural");
                
            case DejalIntervalUnitsNever:
                return NSLocalizedStringFromTable(@"never", @"DejalInterval", @"never");
                
            case DejalIntervalUnitsForever:
                return NSLocalizedStringFromTable(@"forever", @"DejalInterval", @"forever");
                
            default:
                return NSLocalizedStringFromTable(@"secs", @"DejalInterval", @"second plural");
        }
    }
}

/**
 Returns a longer localized string for the units of the receiver, using singular or plural as appropriate for the amount, e.g. "minute" or "weeks".
 
 @author DJS 2007-04.
 @version DJS 2007-07: Changed to add forever.
 @version DJS 2008-07: Changed to use properties.
 @version DJS 2010-06: Changed to use DejalIntervalUnits.
 @version DJS 2011-10: Changed to avoid using my NSDictionary categories, to make more portable.
*/

- (NSString *)fullUnitsName;
{
    if (self.secondAmount == 1)
    {
        switch (self.units)
        {
            case DejalIntervalUnitsMinute:
                return NSLocalizedStringFromTable(@"minute", @"DejalInterval", @"minute singular");
                
            case DejalIntervalUnitsHour:
                return NSLocalizedStringFromTable(@"hour", @"DejalInterval", @"hour singular");
                
            case DejalIntervalUnitsDay:
                return NSLocalizedStringFromTable(@"day", @"DejalInterval", @"day singular");
                
            case DejalIntervalUnitsWeek:
                return NSLocalizedStringFromTable(@"week", @"DejalInterval", @"week singular");
                
            case DejalIntervalUnitsMonth:
                return NSLocalizedStringFromTable(@"month", @"DejalInterval", @"month singular");
                
            case DejalIntervalUnitsYear:
                return NSLocalizedStringFromTable(@"year", @"DejalInterval", @"year singular");
                
            case DejalIntervalUnitsNever:
                return NSLocalizedStringFromTable(@"never", @"DejalInterval", @"never");
            
            case DejalIntervalUnitsForever:
                return NSLocalizedStringFromTable(@"forever", @"DejalInterval", @"forever");
            
            default:
                return NSLocalizedStringFromTable(@"second", @"DejalInterval", @"second singular");
        }
    }
    else
    {
        switch (self.units)
        {
            case DejalIntervalUnitsMinute:
                return NSLocalizedStringFromTable(@"minutes", @"DejalInterval", @"minute plural");
                
            case DejalIntervalUnitsHour:
                return NSLocalizedStringFromTable(@"hours", @"DejalInterval", @"hour plural");
                
            case DejalIntervalUnitsDay:
                return NSLocalizedStringFromTable(@"days", @"DejalInterval", @"day plural");
                
            case DejalIntervalUnitsWeek:
                return NSLocalizedStringFromTable(@"weeks", @"DejalInterval", @"week plural");
                
            case DejalIntervalUnitsMonth:
                return NSLocalizedStringFromTable(@"months", @"DejalInterval", @"month plural");
                
            case DejalIntervalUnitsYear:
                return NSLocalizedStringFromTable(@"years", @"DejalInterval", @"year plural");
                
            case DejalIntervalUnitsNever:
                return NSLocalizedStringFromTable(@"never", @"DejalInterval", @"never");
                
            case DejalIntervalUnitsForever:
                return NSLocalizedStringFromTable(@"forever", @"DejalInterval", @"forever");
                
            default:
                return NSLocalizedStringFromTable(@"seconds", @"DejalInterval", @"second plural");
        }
    }
}

@end

