//
//  DejalData.m
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

#import "DejalData.h"


enum {DejalDataLengthUnknown = NSIntegerMax};

NSUInteger const DejalDataVersion = 1;

NSString * const DejalDataKeyLength = @"length";
NSString * const DejalDataKeyString = @"string";


@interface DejalData ()

@property (nonatomic, strong) NSData *cachedData;
@property (nonatomic) NSUInteger cachedLength;
@property (nonatomic, strong) NSString *cachedString;

@end


@implementation DejalData

/**
 Convenience class method to create a new DejalData instance with nil data.
 
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)data;
{
    return [self dataWithData:nil];
}

/**
 Convenience class method to create a new DejalData instance with the specified OS data.
 
 @param data The data to use.
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)dataWithData:(NSData *)data;
{
    DejalData *obj = [self new];
    
    obj.data = data;
    
    return obj;
}

/**
 Convenience class method to create a new DejalData instance with the specified arbitrary object.
 
 @param object The object to use.
 @returns A new DejalData instance.
 
 @author DJS 2015-08.
 */

+ (instancetype)dataWithObject:(id)object;
{
    DejalData *obj = [self new];
    
    obj.object = object;
    
    return obj;
}

/**
 Initializer from a coder.  Supports secure coding.
 
 @param decoder The coder to use.
 @returns The initialized instance.
 
 @author DJS 2015-08.
 */

- (instancetype)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]))
    {
        // Need to set the length after the string, since setting the string will make it unknown length:
        self.string = [decoder decodeObjectOfClass:[NSString class] forKey:DejalDataKeyString];
        self.length = [decoder decodeIntegerForKey:DejalDataKeyLength];
    }
    
    return self;
}

/**
 Encodes the receiver.
 
 @param encoder The coder to use.
 
 @author DJS 2015-08.
 */

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeObject:self.string forKey:DejalDataKeyString];
    [encoder encodeInteger:self.length forKey:DejalDataKeyLength];
}

/**
 Indicates that this class supports secure coding (needed for XPC).
 
 @author DJS 2015-08.
 */

+ (BOOL)supportsSecureCoding;
{
    return YES;
}

/**
 Populates the receiver's properties with default values.
 
 @author DJS 2015-08.
 */

- (void)loadDefaultValues;
{
    [super loadDefaultValues];
    
    self.version = DejalDataVersion;
    self.length = 0;
    self.data = nil;
}

/**
 Returns the OS data for the receiver.
 
 @author DJS 2015-08.
 */

- (NSData *)data;
{
    if (!self.cachedData && self.cachedString.length)
    {
        self.cachedData = [[NSData alloc] initWithBase64EncodedString:self.cachedString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    
    return self.cachedData;
}

/**
 Sets the receiver to the specified OS data.
 
 @author DJS 2015-08.
 */

- (void)setData:(NSData *)data;
{
    [self willChangeValueForKey:@"data"];
    [self willChangeValueForKey:@"string"];
    [self willChangeValueForKey:@"length"];
    
    self.cachedData = data;
    self.cachedLength = data.length;
    self.cachedString = nil;
    
    [self didChangeValueForKey:@"data"];
    [self didChangeValueForKey:@"string"];
    [self didChangeValueForKey:@"length"];
}

/**
 Returns a Base-64, UTF-8 encoded string representation of the receiver.
 
 @author DJS 2015-08.
 */

- (NSString *)string;
{
    if (!self.cachedString && self.cachedData.length)
    {
        self.cachedString = [self.cachedData base64EncodedStringWithOptions:0];
    }
    
    return self.cachedString;
}

/**
 Sets the receiver to the data represented by the Base-64, UTF-8 encoded string.
 
 @author DJS 2015-08.
 */

- (void)setString:(NSString *)string;
{
    [self willChangeValueForKey:@"data"];
    [self willChangeValueForKey:@"string"];
    [self willChangeValueForKey:@"length"];
    
    self.cachedData = nil;
    self.cachedLength = DejalDataLengthUnknown;
    self.cachedString = string;
    
    [self didChangeValueForKey:@"data"];
    [self didChangeValueForKey:@"string"];
    [self didChangeValueForKey:@"length"];
}

/**
 Returns an arbitrary object representation of the receiver, unarchived from the data.
 
 @author DJS 2015-08.
 */

- (id)object;
{
    return self.data ? [NSKeyedUnarchiver unarchiveObjectWithData:self.data] : nil;
}

/**
 Sets an arbitrary object representation in the receiver, archived to the data.
 
 @author DJS 2015-08.
 */

- (void)setObject:(id)object;
{
    self.data = object ? [NSKeyedArchiver archivedDataWithRootObject:object] : nil;
}

/**
 Read-only property; returns YES if the receiver's data is nil.  Doesn't trigger Base-64 encoding or decoding.
 
 @author DJS 2015-08.
 */

- (BOOL)isEmpty;
{
    return !self.cachedData && !self.cachedString;
}

/**
 Property for the length of the OS data representation of the receiver.
 
 @author DJS 2015-08.
 */

- (NSUInteger)length;
{
    if (self.cachedLength == DejalDataLengthUnknown)
    {
        self.cachedLength = self.data.length;
    }
    
    return self.cachedLength;
}

/**
 Sets the length of the OS data representation of the receiver.
 
 @author DJS 2015-08.
 */

- (void)setLength:(NSUInteger)length;
{
    self.cachedLength = length;
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-08.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DejalDataKeyLength, DejalDataKeyString]];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: %@", [super description], [NSByteCountFormatter stringFromByteCount:self.length countStyle:NSByteCountFormatterCountStyleMemory]];
}

@end

