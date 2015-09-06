//
//  DejalObject.m
//  Dejal Open Source
//
//  Created by David Sinclair on 2011-12-07.
//  Copyright (c) 2011-2015 Dejal Systems, LLC. All rights reserved.
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


NSUInteger const DejalObjectVersion = 1;

NSString * const DejalObjectKeyClassName = @"representedClassName";
NSString * const DejalObjectKeyVersion = @"version";


@interface DejalObject ()

@end


@implementation DejalObject

/**
 Returns a new instance of the receiver.  Subclasses shouldn't need to override this, though may want to define their own edition that calls this.
 
 @author DJS 2011-12.
*/

+ (instancetype)object;
{
    return [self new];
}

/**
 Returns a new instance of the the receiver, populated from the specified JSON data.  Subclasses shouldn't need to override this, though may want to define their own edition that calls this.
 
 @author DJS 2014-01.
*/

+ (instancetype)objectWithJSON:(NSData *)json;
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    
    return [self objectWithDictionary:dict];
}

/**
 Returns a new instance of the the receiver, populated from the specified dictionary.  If the dictionary includes the representedClassName key, that class is used instead of the reciever (thus automatically supporting class clusters).  Subclasses shouldn't need to override this, though may want to define their own edition that calls this.
 
 @author DJS 2011-12.
*/

+ (instancetype)objectWithDictionary:(NSDictionary *)dict;
{
    NSString *className = dict[DejalObjectKeyClassName];
    Class class = NSClassFromString(className);
    
    if (class)
    {
        return [[class alloc] initWithDictionary:dict];
    }
    else
    {
        return [[self alloc] initWithDictionary:dict];
    }
}

/**
 Initializes the receiver, populating from the specified dictionary.  Subclasses shouldn't need to override this; override -setDictionary: instead.
 
 @author DJS 2011-12.
 @version DJS 2015-02: Now uses the dictionary property.
*/

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
{
    if ((self = [self init]))
    {
        self.dictionary = dictionary;
        
        self.hasChanges = NO;
    }
    
    return self;
}

/**
 Initializer from a coder.  Supports secure coding.  Subclasses should override this method, calling super, to add their properties.
 
 @param decoder The coder to use.
 @returns The initialized instance.
 
 @author DJS 2014-01.
 */

- (instancetype)initWithCoder:(NSCoder *)decoder;
{
    if ((self = [self init]))
    {
        [self loadDefaultValues];
        
        self.version = [decoder decodeIntegerForKey:DejalObjectKeyVersion];
        self.hasChanges = NO;
    }
    
    return self;
}

/**
 Designated initializer, using default values.  Subclasses shouldn't need to override this; override -loadDefaultValues instead.
 
 @author DJS 2011-12.
 @version DJS 2015-07: added the old & new options to the observers.
*/

- (instancetype)init;
{
    if ((self = [super init]))
    {
        [self loadDefaultValues];
        
        for (NSString *key in self.savedKeys)
        {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:NULL];
        }
    }
    
    return self;
}

/**
 Removes the Key-Value Observer for the receiver.
 
 @author DJS 2011-12.
*/

- (void)dealloc;
{
    for (NSString *key in self.savedKeys)
    {
        [self removeObserver:self forKeyPath:key];
    }
}

/**
 Populates the receiver's properties with default values.  Subclasses should override this method, optionally calling super, to set up their properties.
 
 @author DJS 2011-12.
*/

- (void)loadDefaultValues;
{
    self.version = DejalObjectVersion;
    
#if TARGET_OS_IPHONE
    self.representedClassName = NSStringFromClass([self class]);
#else
    self.representedClassName = [self className];
#endif
}

/**
 Returns a JSON representation of the receiver, using the savedKeys array.  You should probably set the hasChanges flag to NO after calling this, if the values are being saved.
 
 @author DJS 2014-01.
*/

- (NSData *)json;
{
    return [NSJSONSerialization dataWithJSONObject:self.dictionary options:NSJSONWritingPrettyPrinted error:nil];
}

/**
 Populates the receiver's properties from the JSON, using the savedKeys array.  Doesn't use all keys in the JSON, as there may be obsolete ones.  Subclasses shouldn't need to override this method; instead, they may override the -setDictionary: method to load old keys.
 
 @author DJS 2015-02.
 */

- (void)setJSON:(NSData *)json;
{
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:nil];
    
    self.dictionary = dict;
}

/**
 Returns a dictionary representation of the receiver, using the savedKeys array.  You should probably set the hasChanges flag to NO after calling this, if the values are being saved.  Subclasses may override this method, calling super, if they want to add extra values (e.g. ones that need converting or other special cases).
 
 @author DJS 2011-12.
 @version DJS 2014-01: Changed to recursively get the dictionary representation of objects in the receiver's properties.
 @version DJS 2014-05: Changed to avoid an exception if a value is nil, and recursively get dictionary representations of objects in an array property.
 @version DJS 2014-02: Changed to no longer set hasChanges to NO; it should be done explicitly.
*/

- (NSDictionary *)dictionary;
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.savedKeys)
    {
        id value = [self valueForKey:key];
        
        if ([value isKindOfClass:[NSArray class]] && [[value firstObject] isKindOfClass:[DejalObject class]])
        {
            // The value is an array of represented objects, so make an array of dictionary representations of them:
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:[value count]];
            
            for (DejalObject *object in value)
            {
                NSDictionary *subDict = [object dictionary];
                
                if (subDict)
                {
                    [array addObject:subDict];
                }
            }
            
            value = array;
        }
        else if ([value isKindOfClass:[DejalObject class]])
        {
            value = [value dictionary];
        }
        
        if (value)
        {
            dict[key] = value;
        }
    }
    
    return dict;
}

/**
 Populates the receiver's properties from the dictionary, using the savedKeys array.  Doesn't use all keys in the dictionary, as there may be obsolete ones in the dictionary.  Subclasses may override this method to load old keys via -setValueForKey:fromOldKey:inDictionary:, if desired, then call super to load the current ones.
 
 @author DJS 2011-12.
 @version DJS 2015-02: Renamed from -loadFromDictionary: to setDictionary:, so it works as a property.
 */

- (void)setDictionary:(NSDictionary *)dict;
{
    [self setValuesForKeys:self.savedKeys withDictionary:dict];
}

/**
 NSCopying protocol method, to copy the receiver.
 
 @param zone Ignored.
 @returns A new copy of the receiver.
 
 @author DJS 2014-02.
 */

- (instancetype)copyWithZone:(NSZone *)zone;
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

/**
 Encodes the receiver.  Subclasses should override this method, calling super, to add their properties.
 
 @param encoder The coder to use.
 
 @author DJS 2014-01.
 */

- (void)encodeWithCoder:(NSCoder *)encoder;
{
    [encoder encodeInteger:self.version forKey:DejalObjectKeyVersion];
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
 Determines whether or not another object is equivalent to the receiver.
 
 @param object Another object to compare.
 @returns YES if the two objects are equivalent, otherwise NO.
 
 @author DJS 2015-07.
 */

- (BOOL)isEqual:(id)object;
{
    return [self isEqualToObject:object];
}

/**
 Determines whether or not another object is equivalent to the receiver.  Use this instead of -isEqual: to compare represented objects.
 
 @param object Another object to compare.
 @returns YES if the two objects are equivalent, otherwise NO.
 
 @author DJS 2014-02.
 */

- (BOOL)isEqualToObject:(id)object;
{
    if ([object isKindOfClass:[DejalObject class]])
    {
        return [[self dictionary] isEqualToDictionary:[object dictionary]];
    }
    else
    {
        return NO;
    }
}

/**
 Recursively enumerates through the receiver and all other represented objects contained within the receiver, performing the block for each.  The block can set the stop parameter to YES to prematurely stop enumerating.
 
 @param block A block that takes an object and reference to a stop boolean.
 @returns YES if all contained objects (if any) were enumerated, or NO if the block stopped before completing them all.
 
 @author DJS 2015-02.
 */

- (BOOL)enumerateObjectsUsingBlock:(void (^)(DejalObject *obj, BOOL *stop))block;
{
    if (!block)
    {
        return NO;
    }
    
    BOOL stop = NO;
    
    block(self, &stop);
    
    if (stop)
    {
        return NO;
    }
    
    for (NSString *key in self.savedKeys)
    {
        id value = [self valueForKey:key];
        
        // It's an array of represented objects, so recursively enumerate each of them, otherwise recursively enumerate the receivers represented objects:
        if ([value isKindOfClass:[NSArray class]] && [[value firstObject] isKindOfClass:[DejalObject class]])
        {
            for (DejalObject *object in value)
            {
                if (![object enumerateObjectsUsingBlock:block])
                {
                    return NO;
                }
            }
        }
        else if ([value isKindOfClass:[DejalObject class]] && ![(DejalObject *)value enumerateObjectsUsingBlock:block])
        {
            return NO;
        }
    }
    
    return YES;
}

/**
 Detect changes in the receiver or any contained represented objects.
 
 @returns YES if there are any changes, otherwise NO.
 
 @author DJS 2015-02.
 */

- (BOOL)hasAnyChanges;
{
    // Enumerate through the represented objects; if we make it through them all without stopping, there aren't any changes:
    return ![self enumerateObjectsUsingBlock:^(DejalObject *obj, BOOL *stop)
             {
                 if (obj.hasChanges)
                 {
                     *stop = YES;
                 }
             }];
}

/**
 Sets the hasChanges property to NO for the receiver and all contained represented objects.
 
 @author DJS 2014-02.
 */

- (void)clearChanges;
{
    [self enumerateObjectsUsingBlock:^(DejalObject *obj, BOOL *stop)
     {
         obj.hasChanges = NO;
     }];
}

/**
 Automatically convert any dictionary representation to a represented object, or an array of dictionary representations to an array of represented objects.
 
 @param value The value to process.
 @returns The processed value.
 
 @author DJS 2014-05.
 */

- (id)processValue:(id)value;
{
    if ([value isKindOfClass:[NSDictionary class]])
    {
        NSString *className = [value valueForKey:DejalObjectKeyClassName];
        Class class = NSClassFromString(className);
        DejalObject *obj = nil;
        
        if (class)
        {
            obj = [[class alloc] initWithDictionary:value];
        }
        
        if (obj)
        {
            return obj;
        }
    }
    else if ([value isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[value count]];
        
        for (id object in value)
        {
            id processed = [self processValue:object];
            
            if (processed)
            {
                [array addObject:object];
            }
        }
        
        return array;
    }
    
    return value;
}

/**
 Sets the properties with the specified keys from the dictionary.  Only sets the properties if there are corresponding values in the dictionary; otherwise the previous values remain (e.g. from the default values).  Subclasses shouldn't need to override this.
 
 @author DJS 2011-12.
 @version DJS 2014-01: Changed to recursively set a dictionary representation as a represented object.
 @version DJS 2014-05: Changed to recursively set an array of dictionary representations as an array of represented objects.
 @version DJS 2015-02: Bails out if the dictionary is nil.
*/

- (void)setValuesForKeys:(NSArray *)keys withDictionary:(NSDictionary *)dict;
{
    if (!dict)
    {
        return;
    }
    
    for (NSString *key in keys)
    {
        id value = [self processValue:dict[key]];
        
        if (value)
        {
            [self setValue:value forKey:key];
        }
    }
}

/**
 Sets the property with the specified key to the value from the dictionary with the old key.  Only sets the property if there is a corresponding value in the dictionary; otherwise the previous value remains (e.g. from the default values).  Subclasses shouldn't need to override this, but may want to call it from -setDictionary: if they have old keys.
 
 @author DJS 2011-12.
 @version DJS 2015-04: Changed to process the value to support embedded represented objects.
*/

- (void)setValueForKey:(NSString *)key fromOldKey:(NSString *)oldKey inDictionary:(NSDictionary *)dict;
{
    id value = [self processValue:dict[oldKey]];
    
    if (value)
    {
        [self setValue:value forKey:key];
    }
}

/**
 Key-Value Observing method when one of the saved properties of the receiver changes.  Simply sets the hasChanges flag.  Subclasses shouldn't need to override this.
 
 @author DJS 2011-12.
 @version DJS 2015-07: Only sets the changes flag if the old and new values aren't equal.
*/

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (![change[@"old"] isEqual:change[@"new"]])
    {
        self.hasChanges = YES;
    }
}

/**
 Returns the class name of the receiver.  Used to save a dictionary representation of the receiver within another represented object.
 
 @author DJS 2014-01.
*/

- (NSString *)representedClassName;
{
#if TARGET_OS_IPHONE
    return NSStringFromClass([self class]);
#else
    return [self className];
#endif
}

/**
 Placeholder set accessor; does nothing.  Needed to avoid an error, since this property is one of the saved keys.
 
 @author DJS 2014-01.
*/

- (void)setRepresentedClassName:(NSString *)representedClassName;
{
    // Does nothing
}

/**
 Returns an array of keys that correspond to the defined properties of the receiver.  These are used to load from and save to a dictionary.  Subclasses must override this method, calling super, to add their own properties.
 
 @author DJS 2011-12.
 @version DJS 2014-01: Changed to add DejalObjectKeyClassName.
*/

- (NSArray *)savedKeys;
{
    return @[DejalObjectKeyVersion, DejalObjectKeyClassName];
}

/**
 A string representation of the receiver, including the class name, for debugging.
 
 @author DJS 2015-09.
 */

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@%@", self.representedClassName, self.hasAnyChanges ? @" [CHANGED]" : @""];
}

@end

