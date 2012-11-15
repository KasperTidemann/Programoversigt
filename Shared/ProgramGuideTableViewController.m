//
//  ProgramGuideTableViewController.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import "ProgramGuideTableViewController.h"

#define IPAD_FONT_SIZE 50
#define IPHONE_FONT_SIZE 32

@implementation ProgramGuideTableViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	programItemCells = [[NSMutableArray alloc] initWithCapacity:10];
	
	//make header label
	NSInteger fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? IPAD_FONT_SIZE : IPHONE_FONT_SIZE;
	headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.frame.size.width, fontSize + 10)];
	headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerLabel.textAlignment = NSTextAlignmentCenter;
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.font = [UIFont fontWithName:@"Handage AOE" size:fontSize];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

#pragma mark -
#pragma mark Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (programItemCells) ? [programItemCells count] : 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (ProgramItemCell *)[programItemCells objectAtIndex:indexPath.row];
    
    //add gesture recognizer for menu display
    UILongPressGestureRecognizer *r = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasLongPressed:)];
    [r setMinimumPressDuration:0.3f];
    [cell addGestureRecognizer:r];
    [r release];

    return cell;
}

- (void)cellWasLongPressed:(UILongPressGestureRecognizer *)recognizer{
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        //make and show menu with copy option
        ProgramItemCell *cell = (ProgramItemCell *)recognizer.view;
        [cell becomeFirstResponder];
        
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        UIMenuItem *listMenuItem = [[UIMenuItem alloc] initWithTitle:@"Kopier" action:@selector(copyItem:)];
        [menuController setMenuItems:[NSArray arrayWithObject:listMenuItem]];
        [menuController setTargetRect:cell.frame inView:self.view];
        
        // animate cell
        [UIView animateWithDuration:0.5f
							  delay:0.0f
							options:UIViewAnimationOptionCurveEaseInOut
						 animations:^{
							 cell.alpha = 0.25f;
                             cell.alpha = 1.0f;
						 }
						 completion:^(BOOL finished){
                             [menuController setMenuVisible:YES animated:YES];
						 }];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [programItemCells objectAtIndex:indexPath.row];
	return cell.frame.size.height;
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[programItemCells release];
	[headerLabel release];
    [super dealloc];
}

- (void)loadProgram:(NSDictionary *)programDic {
	NSString *headerTitle = (NSString *)[programDic objectForKey:kHeaderTitleKey];
	NSArray *programTimes = (NSArray *)[programDic objectForKey:kProgramTimesKey];
	NSArray *programItems = (NSArray *)[programDic objectForKey:kProgramItemsKey];
	
	if (programItems) {
		[self tableHeaderTitle:headerTitle];
		
		[programItemCells removeAllObjects];
		
		[self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
		
		[self.tableView beginUpdates];
		
		CGFloat cellWidth = self.tableView.frame.size.width;
		
		if (programTimes && [programTimes count] == [programItems count]) {
			NSInteger numberOfItems = [programItems count];
			
			for (NSInteger i = 0; i < numberOfItems; i++) {
				[programItemCells addObject:[[ProgramItemCell alloc] initWithTime:[programTimes objectAtIndex:i] 
																	  description:[programItems objectAtIndex:i] 
																			width:cellWidth]];
			}
			
		} else {
			for (NSString *item in programItems) {
				[programItemCells addObject:[[ProgramItemCell alloc] initWithDescription:item width:cellWidth]];
			}
		}
		
		[self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationFade];
		
		[self.tableView endUpdates];
	}
}

- (void)tableHeaderTitle:(NSString *)tableHeaderTitle {
	if (tableHeaderTitle) {
		headerLabel.text = tableHeaderTitle;
		self.tableView.tableHeaderView = headerLabel;
	} else {
		self.tableView.tableHeaderView = nil;
	}
}

@end

