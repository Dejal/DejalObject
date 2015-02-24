//
//  Demo.h
//  DejalObject Demo
//
//  Created by David Sinclair on 2015-02-23.
//  Copyright (c) 2015 Dejal Systems, LLC. All rights reserved.
//

#import "DejalObject.h"
#import "DejalColor.h"
#import "DejalDate.h"


@interface Demo : DejalObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic) NSInteger number;
@property (nonatomic, strong) DejalColor *label;
@property (nonatomic, strong) DejalDate *when;

@end

