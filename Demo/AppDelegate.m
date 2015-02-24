//
//  AppDelegate.m
//  DejalObject Demo
//
//  Created by David Sinclair on 2012-03-24.
//  Copyright (c) 2012-2015 Dejal Systems, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "Demo.h"


@interface AppDelegate ()

@property (nonatomic, strong) Demo *demo;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"demo"];
    
    self.demo = [Demo objectWithDictionary:dict];
    
    self.textField.stringValue = self.demo.text;
    self.numberField.integerValue = self.demo.number;
    self.colorWell.color = self.demo.label.color;
    self.datePicker.dateValue = self.demo.when.date;
}

- (IBAction)changed:(id)sender;
{
    if (self.demo)
    {
        self.demo.text = self.textField.stringValue;
        self.demo.number = self.numberField.integerValue;
        self.demo.label.color = self.colorWell.color;
        self.demo.when.date = self.datePicker.dateValue;
        
        NSLog(@"Demo data: %@", self.demo);  // log
        
        [[NSUserDefaults standardUserDefaults] setObject:self.demo.dictionary forKey:@"demo"];
    }
}

@end

