//
//  Demo.m
//  DejalObject Demo
//
//  Created by David Sinclair on 2015-02-23.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
//

#import "Demo.h"


NSUInteger const DemoVersion = 1;

NSString * const DemoKeyText = @"text";
NSString * const DemoKeyNumber = @"number";
NSString * const DemoKeyLabel = @"label";
NSString * const DemoKeyWhen = @"when";


@implementation Demo

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
        self.text = [decoder decodeObjectOfClass:[NSString class] forKey:DemoKeyText];
        self.number = [decoder decodeIntegerForKey:DemoKeyNumber];
        self.label = [decoder decodeObjectOfClass:[DejalColor class] forKey:DemoKeyLabel];
        self.when = [decoder decodeObjectOfClass:[DejalDate class] forKey:DemoKeyWhen];
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
    
    [encoder encodeObject:self.text forKey:DemoKeyText];
    [encoder encodeInteger:self.number forKey:DemoKeyNumber];
    [encoder encodeObject:self.label forKey:DemoKeyLabel];
    [encoder encodeObject:self.when forKey:DemoKeyWhen];
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
    
    self.version = DemoVersion;
    self.text = @"Foo";
    self.number = 12345;
    self.label = [DejalColor colorWithColor:[NSColor blueColor]];
    self.when = [DejalDate dateWithNow];
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.
 
 @returns The keys for the properties.
 
 @author DJS 2015-02.
 */

- (NSArray *)savedKeys;
{
    return [[super savedKeys] arrayByAddingObjectsFromArray:@[DemoKeyText, DemoKeyNumber, DemoKeyLabel, DemoKeyWhen]];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: text = '%@'; number = %@; color = %@; when = %@", [self className], self.text, @(self.number), self.label, self.when];
}

@end

