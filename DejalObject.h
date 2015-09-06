//
//  DejalObject.h
//  Dejal Open Source
//
//  Created by David Sinclair on 2011-12-07.
//  Copyright (c) 2011-2015 Dejal Systems, LLC. All rights reserved.
//
//  This class is an abstract data model that can represent subclasses as
//  dictionary or JSON data for saving to disk or over the network.
//  See DejalDate and DejalInterval for examples of usage.
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


@interface DejalObject : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic, strong, setter=setJSON:) NSData *json;
@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong, readonly) NSArray *savedKeys;
@property (nonatomic) NSUInteger version;
@property (nonatomic, strong) NSString *representedClassName;
@property (nonatomic) BOOL hasChanges;
@property (nonatomic, readonly) BOOL hasAnyChanges;

+ (instancetype)object;
+ (instancetype)objectWithJSON:(NSData *)json;
+ (instancetype)objectWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

- (void)loadDefaultValues;

- (BOOL)isEqualToObject:(id)object;

- (BOOL)enumerateObjectsUsingBlock:(void (^)(DejalObject *obj, BOOL *stop))block;

- (void)clearChanges;

- (void)setValueForKey:(NSString *)key fromOldKey:(NSString *)oldKey inDictionary:(NSDictionary *)dict;

@end

