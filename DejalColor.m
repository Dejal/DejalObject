//
//  DejalColor.m
//  Shared
//
//  Created by David Sinclair on 2014-01-10.
//  Copyright (c) 2014-2015 Dejal Systems, LLC. All rights reserved.
//
//  This class is useful to store colors in represented objects, including automatic
//  dictionary or JSON encoding.  It supports both OS X and iOS colors.
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

#import "DejalColor.h"


NSUInteger const DejalColorVersion = 1;

NSString * const DejalColorKeyRed = @"red";
NSString * const DejalColorKeyGreen = @"green";
NSString * const DejalColorKeyBlue = @"blue";
NSString * const DejalColorKeyAlpha = @"alpha";


@interface DejalColor ()

@property (nonatomic, strong) OSColor *cachedColor;

@end


@implementation DejalColor

/**
 Convenience class method to create a new DejalColor instance with the specified OS color.
 
 @param color The color to use.
 @returns A new DejalColor instance.
 
 @author DJS 2014-01.
 */

+ (instancetype)colorWithColor:(OSColor *)color;
{
    return [[self alloc] initWithColor:color];
}

/**
 Convenience class method to create a new DejalColor instance from a dictionary representation.
 
 @param dict A dictionary (as returned by the -dictionary method).
 @returns A new DejalColor instance.
 
 @author DJS 2014-01.
 */

+ (instancetype)colorWithDictionary:(NSDictionary *)dict;
{
    return [[self alloc] initWithDictionary:dict];
}

/**
 Designated initializer.
 
 @param color The color to use.
 @returns The initialized DejalColor instance.
 
 @author DJS 2014-01.
 */

- (instancetype)initWithColor:(OSColor *)color;
{
    if ((self = [super init]))
    {
        self.color = color;
    }
    
    return self;
}

/**
 Initializer from a coder.  Supports secure coding.
 
 @param decoder The coder to use.
 @returns The initialized instance.
 
 @author DJS 2014-01.
 @version DJS 2015-02: Updated to use DejalObject as a superclass.
 */

- (instancetype)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [super initWithCoder:decoder]))
    {
        self.red = [decoder decodeFloatForKey:DejalColorKeyRed];
        self.green = [decoder decodeFloatForKey:DejalColorKeyGreen];
        self.blue = [decoder decodeFloatForKey:DejalColorKeyBlue];
        self.alpha = [decoder decodeFloatForKey:DejalColorKeyAlpha];
    }
    
    return self;
}

/**
 Encodes the receiver.
 
 @param encoder The coder to use.
 
 @author DJS 2014-01.
 @version DJS 2015-02: Updated to use DejalObject as a superclass.
 */

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [super encodeWithCoder:encoder];
    
    [encoder encodeFloat:self.red forKey:DejalColorKeyRed];
    [encoder encodeFloat:self.green forKey:DejalColorKeyGreen];
    [encoder encodeFloat:self.blue forKey:DejalColorKeyBlue];
    [encoder encodeFloat:self.alpha forKey:DejalColorKeyAlpha];
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
 Populates the receiver's properties with default values.
 
 @author DJS 2015-02.
 */

- (void)loadDefaultValues;
{
    [super loadDefaultValues];
    
    self.version = DejalColorVersion;
    self.color = nil;
}

/**
 Returns an OS color object representing the receiver's color properties.
 
 @author DJS 2015-02.
 */

- (OSColor *)color;
{
    if (!self.cachedColor)
    {
        self.cachedColor = [OSColor colorWithCalibratedRed:self.red green:self.green blue:self.blue alpha:self.alpha];
    }
    
    return self.cachedColor;
}

/**
 Sets the receiver's color properties based on the specified OS color.
 
 @author DJS 2015-02.
 */

- (void)setColor:(OSColor *)color;
{
    // Make sure it's in the RGB space:
    color = [color colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    
    self.red = color.redComponent;
    self.green = color.greenComponent;
    self.blue = color.blueComponent;
    self.alpha = color.alphaComponent;
    self.cachedColor = color;
}

/**
 Key-Value Observing method when one of the saved properties of the receiver changes.
 
 @author DJS 2015-02.
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    self.cachedColor = nil;
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-02.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DejalColorKeyRed, DejalColorKeyGreen, DejalColorKeyBlue, DejalColorKeyAlpha]];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: red: %@, green: %@, blue: %@, alpha: %@", [self className], @(self.red), @(self.green), @(self.blue), @(self.alpha)];
}

@end

