//
//  GenericGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/21/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "GenericGenerator.h"

@implementation GenericGenerator

@synthesize iconImage;
@synthesize iconTextImage;
@synthesize iconHighlightedTextImage;
@synthesize buttonImage;
@synthesize hasNextPrevButtons;

- (id)init {
	if (self == [super init]) {
        hasNextPrevButtons = YES;
    }
    
    programLength = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? IPAD_PROGRAM_LENGTH : IPHONE_PROGRAM_LENGTH;
    
	return self;
}

//make array from file, where every line is parsed as a seperate string
- (NSArray *)arrayFromFile:(NSString *)path {
	
	NSError *error = nil;
	
	NSString *file = [NSString stringWithContentsOfFile:path 
											   encoding:NSUTF8StringEncoding 
												  error:&error];
	
	//if the file could not be read then return an empty array
	if (error) {
		return [NSArray array];
	}
	
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
	
	NSCharacterSet *cs = [NSCharacterSet newlineCharacterSet];
	
	NSScanner *scanner = [NSScanner scannerWithString:file];
	
	NSString *line;
	
	while(![scanner isAtEnd]) {
		if([scanner scanUpToCharactersFromSet:cs intoString:&line]) {
			NSString *string = [NSString stringWithString:line];
			[arr addObject:string];
		}
	}
	
	return [NSArray arrayWithArray:arr];
}

- (NSDictionary *)currentProgram {
	
	return [self randomProgram];
}

- (NSDictionary *)randomProgram {
	
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:3];
	NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:programLength];
	
	for (NSInteger i = 0; i < programLength; i++) {
		[tempArr addObject:[self itemString]];
		[NSThread sleepForTimeInterval:0.02f];
	}
	[tempDic setObject:tempArr forKey:kProgramItemsKey];
	[tempDic setObject:[self headerString] forKey:kHeaderTitleKey];
	
	return [NSDictionary dictionaryWithDictionary:tempDic];
}

- (NSDictionary *)nextProgram {
	
	return [self randomProgram];
}

- (NSDictionary *)prevProgram {
	
	return [self randomProgram];
}

- (NSString *)itemString {
	//override
	return @"item";
}

- (NSString *)timeString {
	//override
	return @"time";
}

- (NSString *)headerString {
	//override
	return @"header";
}

- (void)dealloc {
	[textDictionary release];
	[iconImage release];
    [iconTextImage release];
    [iconHighlightedTextImage release];
	[buttonImage release];
	[super dealloc];
}

@end
