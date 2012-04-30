    //
//  DetailViewController.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/16/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "DetailViewController.h"
#import "ProgramGuideTableViewController.h"
#import "AppDelegate_iPad.h"

@interface DetailViewController ()

@property (nonatomic, retain) UIPopoverController *popoverController;

- (void)setTableViewFrame;

@end

@implementation DetailViewController

@synthesize programGuideTableViewController;
@synthesize toolbar;
@synthesize popoverController;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[self setTableViewFrame];
}

#pragma mark -
#pragma mark Split view support

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    barButtonItem.title = @"Generatortype";
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
	
	self.toolbar.hidden = NO;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    NSMutableArray *items = [[toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
	
	self.toolbar.hidden = YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self setTableViewFrame];
	
	//reload table with new data to adjust cells and their labels - semi ugly hack
	[(AppDelegate_iPad *)[[UIApplication sharedApplication] delegate] generateProgramGuide:self];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[UIView animateWithDuration:0.2f
					 animations:^{
						 programGuideTableViewController.tableView.alpha = 0.0f;
						 ((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).generatorIconView.alpha = 0.0f;
						 ((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).randomButton.alpha = 0.0f;
					 }];
}

- (void)setTableViewFrame {
	programGuideTableViewController.tableView.alpha = 0.0f;
	((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).generatorIconView.alpha = 0.0f;
	
	if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		programGuideTableViewController.tableView.frame = CGRectMake(79.0f, 71.0f, 546.0f, 610.0f);
		((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).generatorIconView.frame = CGRectMake(199.0f, 640.0f, 70.0f, 93.0f);
	} else {
		programGuideTableViewController.tableView.frame = CGRectMake(83.0f, 93.0f, 607.0f, 820.0f);
		((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).generatorIconView.frame = CGRectMake(235.0f, 890.0f, 70.0f, 93.0f);
	}
	
	[UIView animateWithDuration:0.5f
					 animations:^{
						 programGuideTableViewController.tableView.alpha = 1.0f;
						 ((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).generatorIconView.alpha = 1.0f;
						 ((AppDelegate_iPad *)[[UIApplication sharedApplication] delegate]).randomButton.alpha = 1.0f;
					 }];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
	self.popoverController = nil;
}


- (void)dealloc {
	[programGuideTableViewController release];
	[toolbar release],
	[popoverController release];
    [super dealloc];
}


@end
