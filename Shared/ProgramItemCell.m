//
//  ProgramItemCell.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/11/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "ProgramItemCell.h"

#define MARGIN_X 10
#define MARGIN_Y 10
#define LABEL_MARGIN 10
#define MAX_TIME_WIDTH 60
#define IPAD_FONT_SIZE 40
#define IPHONE_FONT_SIZE 25

static NSString *font = @"Handage AOE";

@implementation ProgramItemCell

- (id)initWithDescription:(NSString *)description width:(CGFloat)cellWidth {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"]) {
		NSInteger fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? IPAD_FONT_SIZE : IPHONE_FONT_SIZE;
		
        //get height of description text
		CGSize textSize = [description sizeWithFont:[UIFont fontWithName:font size:fontSize] constrainedToSize:CGSizeMake(cellWidth-2*MARGIN_X, MAXFLOAT)];
		
		//give the cell a new height matching the text height
		CGFloat cellHeight = (textSize.height < (44-2*MARGIN_Y)) ? 44 : textSize.height + 2*MARGIN_Y;
		self.frame = CGRectMake(0, 0, cellWidth, cellHeight);
		
		//make the description label
		descriptionLabel = [UILabel new];
		descriptionLabel.frame = CGRectMake(MARGIN_X, MARGIN_Y, cellWidth - 2*MARGIN_X, cellHeight - 2*MARGIN_Y);
		descriptionLabel.text = description;
		descriptionLabel.numberOfLines = 0;
		descriptionLabel.font = [UIFont fontWithName:font size:fontSize];
		descriptionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		descriptionLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:descriptionLabel];
		
		self.contentView.backgroundColor = [UIColor clearColor];
		self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.userInteractionEnabled = YES;
    }
    return self;
}

- (id)initWithTime:(NSString *)time description:(NSString *)description width:(CGFloat)cellWidth {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"itemCell"]) {
		NSInteger fontSize = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? IPAD_FONT_SIZE : IPHONE_FONT_SIZE;
		NSInteger maxTimeWidth = cellWidth / 3;
		
		//get size of time label
		CGSize timeSize = [time sizeWithFont:[UIFont fontWithName:font size:fontSize] constrainedToSize:CGSizeMake(maxTimeWidth, MAXFLOAT)];
		
		CGFloat textWidth = cellWidth-2*MARGIN_X - LABEL_MARGIN - timeSize.width;
		
        //get height of description text
		CGSize textSize = [description sizeWithFont:[UIFont fontWithName:font size:fontSize] constrainedToSize:CGSizeMake(textWidth, MAXFLOAT)];
		
		//give the cell a new height matching the text height
		CGFloat cellHeight = (timeSize.height < textSize.height) ? textSize.height : timeSize.height;
		cellHeight = (cellHeight < (44-2*MARGIN_Y)) ? 44 : cellHeight + 2*MARGIN_Y;
		self.frame = CGRectMake(0, 0, cellWidth, cellHeight);
		
		//make the time label
		timeLabel = [UILabel new];
		timeLabel.frame = CGRectMake(MARGIN_X, MARGIN_Y, timeSize.width, timeSize.height);
		timeLabel.text = time;
		timeLabel.numberOfLines = 0;
		timeLabel.font = [UIFont fontWithName:font size:fontSize-2];
		timeLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:timeLabel];
		
		//make the description label
		descriptionLabel = [UILabel new];
		descriptionLabel.frame = CGRectMake(MARGIN_X + timeSize.width + LABEL_MARGIN, MARGIN_Y, textWidth, cellHeight - 2*MARGIN_Y);
		descriptionLabel.text = description;
		descriptionLabel.numberOfLines = 0;
		descriptionLabel.font = [UIFont fontWithName:font size:fontSize];
		//descriptionLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		descriptionLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:descriptionLabel];
		
		self.contentView.backgroundColor = [UIColor clearColor];
		self.backgroundView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
		self.userInteractionEnabled = YES;
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyItem:)) {
        return YES;
    } else {
        return NO;
    }
}

- (void)copyItem:(id)sender {
    UIPasteboard *generalPasteBoard = [UIPasteboard generalPasteboard];
    [generalPasteBoard setString:descriptionLabel.text];
}

- (void)dealloc {
	[timeLabel release];
	[descriptionLabel release];
    [super dealloc];
}


@end
