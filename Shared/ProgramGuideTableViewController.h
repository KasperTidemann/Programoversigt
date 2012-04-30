//
//  ProgramGuideTableViewController.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgramItemCell.h"
#import "Constants.h"


@interface ProgramGuideTableViewController : UITableViewController {
	NSMutableArray *programItemCells;
	UILabel *headerLabel;
}

- (void)loadProgram:(NSDictionary *)programDic;
- (void)tableHeaderTitle:(NSString *)tableHeaderTitle;

@end
