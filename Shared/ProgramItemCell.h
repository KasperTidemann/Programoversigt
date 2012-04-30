//
//  ProgramItemCell.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/11/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProgramItemCell : UITableViewCell {
	UILabel *timeLabel;
	UILabel *descriptionLabel;
}

- (id)initWithDescription:(NSString *)description width:(CGFloat)cellWidth;
- (id)initWithTime:(NSString*)time description:(NSString *)description width:(CGFloat)cellWidth;

@end
