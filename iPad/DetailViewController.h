//
//  DetailViewController.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/16/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgramGuideTableViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate> {
	ProgramGuideTableViewController *programGuideTableViewController;
	UIToolbar *toolbar;
	UIPopoverController *popoverController;
}

@property (nonatomic, retain) IBOutlet ProgramGuideTableViewController *programGuideTableViewController;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (void)setTableViewFrame;

@end
