//
//  STFUAppDelegate.m
//  Shut Up
//
//  Created by Darren Mo on 2014-04-13.
//  Copyright (c) 2014 Darren Mo. All rights reserved.
//

#import "STFUAppDelegate.h"
#import "STFUNoiseCanceller.h"

@interface STFUAppDelegate ()

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSMenu *statusMenu;
@property (strong, nonatomic) NSMenuItem *quitMenuItem;

@property (strong, nonatomic) STFUNoiseCanceller *noiseCanceller;

@end

@implementation STFUAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	self.quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit:) keyEquivalent:@""];
	
	self.statusMenu = [[NSMenu alloc] initWithTitle:@"STFU"];
	[self.statusMenu addItem:self.quitMenuItem];
	
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
	[self.statusItem setTitle:@"STFU"];
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setMenu:self.statusMenu];
	
	self.noiseCanceller = [[STFUNoiseCanceller alloc] init];
	[self.noiseCanceller startCancellingNoise];
}

- (void)quit:(id)sender {
	[NSApp terminate:self];
}

@end
