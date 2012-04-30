//
//  GenericGenerator.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/21/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <stdlib.h>
#import "Constants.h"

#define IPHONE_PROGRAM_LENGTH 3
#define IPAD_PROGRAM_LENGTH 8

@interface GenericGenerator : NSObject {
	NSDictionary *textDictionary;
	UIImage *iconImage;
    UIImage *iconTextImage;
    UIImage *iconHighlightedTextImage;
	UIImage *buttonImage;
    BOOL hasNextPrevButtons;
    NSInteger programLength;
}

@property (nonatomic, readonly) UIImage *iconImage;
@property (nonatomic, readonly) UIImage *iconTextImage;
@property (nonatomic, readonly) UIImage *iconHighlightedTextImage;
@property (nonatomic, readonly) UIImage *buttonImage;
@property (nonatomic, readonly) BOOL hasNextPrevButtons;

- (NSArray *)arrayFromFile:(NSString *)path;
- (NSDictionary *)currentProgram;
- (NSDictionary *)randomProgram;
- (NSDictionary *)nextProgram;
- (NSDictionary *)prevProgram;
- (NSString *)itemString;
- (NSString *)timeString;
- (NSString *)headerString;


@end
