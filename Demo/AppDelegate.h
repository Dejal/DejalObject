//
//  AppDelegate.h
//  DejalObject Demo
//
//  Created by David Sinclair on 2012-03-24.
//  Copyright (c) 2012-2015 Dejal Systems, LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *textField;
@property (assign) IBOutlet NSTextField *numberField;
@property (assign) IBOutlet NSColorWell *colorWell;
@property (assign) IBOutlet NSDatePicker *datePicker;

- (IBAction)changed:(id)sender;

@end

