//
//  DejalInterval.h
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

#import "DejalObject.h"


// These are stored in saved data, so don't insert new values; append to the end:

typedef NS_ENUM(NSInteger, DejalIntervalUnits)
{
    DejalIntervalUnitsSecond = 0,
    DejalIntervalUnitsMinute,
    DejalIntervalUnitsHour,
    DejalIntervalUnitsDay,
    DejalIntervalUnitsWeek,
    DejalIntervalUnitsMonth,
    DejalIntervalUnitsQuarter,
    DejalIntervalUnitsYear,
    DejalIntervalUnitsNever,
    DejalIntervalUnitsForever
};

typedef NS_ENUM(NSInteger, DejalIntervalAmount)
{
    DejalIntervalAmountNever = 0,
    DejalIntervalAmountSecond = 1,
    DejalIntervalAmountMinute = 60,
    DejalIntervalAmountHour = (60 * 60),
    DejalIntervalAmountDay = (60 * 60 * 24),
    DejalIntervalAmountWeek = (60 * 60 * 24 * 7),
    DejalIntervalAmountMonth = (60 * 60 * 24 * 365 / 12),
    DejalIntervalAmountQuarter = (60 * 60 * 24 * 365 / 4),
    DejalIntervalAmountYear = (60 * 60 * 24 * 365),
    DejalIntervalAmountForever = INT_MAX
};


@interface DejalInterval : DejalObject

@property (nonatomic) BOOL usingRange;
@property (nonatomic) NSInteger firstAmount;
@property (nonatomic) NSInteger secondAmount;
@property (nonatomic) NSInteger amount;
@property (nonatomic) DejalIntervalUnits units;
@property (nonatomic, strong) NSMutableDictionary *extraValues;
@property (nonatomic, readonly) NSTimeInterval amountTimeInterval;
@property (nonatomic, readonly) NSTimeInterval firstTimeInterval;
@property (nonatomic, readonly) NSTimeInterval secondTimeInterval;
@property (nonatomic, readonly) NSTimeInterval rangeDifferenceInterval;
@property (nonatomic, readonly) NSTimeInterval unitsTimeInterval;
@property (nonatomic, strong, readonly) NSString *amountWithBriefUnitsName;
@property (nonatomic, strong, readonly) NSString *amountWithFullUnitsName;
@property (nonatomic, strong, readonly) NSString *briefUnitsName;
@property (nonatomic, strong, readonly) NSString *fullUnitsName;

+ (instancetype)intervalWithAmount:(NSInteger)amount units:(DejalIntervalUnits)aUnits;
+ (instancetype)intervalWithRangeFirstAmount:(NSInteger)aFirstAmount secondAmount:(NSInteger)aSecondAmount units:(DejalIntervalUnits)aUnits;

+ (instancetype)intervalWithDictionary:(NSDictionary *)dict;

@end

