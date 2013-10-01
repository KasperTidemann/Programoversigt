    //
//  OptionsViewController.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/16/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "OptionsViewController.h"


@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.preferredContentSize = CGSizeMake(320.0f, 250.0f);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)dealloc {
	[super dealloc];
}

@end
