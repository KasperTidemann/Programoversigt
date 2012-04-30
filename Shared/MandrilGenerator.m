//
//  MandrilGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/15/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "MandrilGenerator.h"

@implementation MandrilGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_mandril_plain"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_mandril_text"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_mandril_hilight"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_mandril"] retain];
        hasNextPrevButtons = YES;
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSArray *timesArray = [self arraysFromFile:[mainBundle pathForResource:@"mandril_times" ofType:@"txt"]];
		NSArray *itemsArray = [self arraysFromFile:[mainBundle pathForResource:@"mandril_items" ofType:@"txt"]];
		NSArray *headersArray = [self arrayFromFile:[mainBundle pathForResource:@"mandril_headers" ofType:@"txt"]];
		
		textDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:timesArray,itemsArray,headersArray,nil] 
													   forKeys:[NSArray arrayWithObjects:kProgramTimesKey,kProgramItemsKey,kHeaderTitleKey,nil]];
        
        currentIndex = 0;
        noOfItems = [itemsArray count];
	}
	
	return self;
}

//make array of arrays from file, where every line is parsed as a seperate string
- (NSArray *)arraysFromFile:(NSString *)path {
	
	NSError *error = nil;
	NSString *file = [NSString stringWithContentsOfFile:path 
											   encoding:NSUTF8StringEncoding 
												  error:&error];
	
	//if the file could not be read then return an empty array
	if (error) {
		return [NSArray array];
	}
	
	NSMutableArray *returnArr = [NSMutableArray arrayWithCapacity:69];
	NSMutableArray *subArr = nil;
	
	NSCharacterSet *cs = [NSCharacterSet newlineCharacterSet];
	
	NSScanner *scanner = [NSScanner scannerWithString:file];
	
	NSString *line;
	
	while(![scanner isAtEnd]) {
		if([scanner scanUpToCharactersFromSet:cs intoString:&line]) {
			NSString *string = [NSString stringWithString:line];
			
			//make all strings uppercase
			string = [string uppercaseString];
			
			//the string "---" seperates each program guide from the next
			if ([string hasPrefix:@"---"]) {
				
				if (subArr) [returnArr addObject:[NSArray arrayWithArray:subArr]];
				
				subArr = [NSMutableArray arrayWithCapacity:7];
				
			} else if (subArr) {
				[subArr addObject:string];
				
			}
		}
	}
	if (subArr) [returnArr addObject:[NSArray arrayWithArray:subArr]];
	
	return [NSArray arrayWithArray:returnArr];
}

- (NSDictionary *)currentProgram {
	
	return [self getProgram];
}

- (NSDictionary *)randomProgram {
	
	//determine which program to return
	currentIndex = arc4random() % noOfItems;

    return [self getProgram];
}

- (NSDictionary *)nextProgram {
	
	currentIndex = (currentIndex + 1) % noOfItems;
	
	return [self getProgram];
}

- (NSDictionary *)prevProgram {
    if (currentIndex == 0) {
        currentIndex = noOfItems - 1;
    } else {
        currentIndex = (currentIndex - 1) % noOfItems;
    }
	
	return [self getProgram];
}

- (NSDictionary *)getProgram {
	
	NSArray *timesArray = (NSArray *)[textDictionary objectForKey:kProgramTimesKey];
	NSArray *itemsArray = (NSArray *)[textDictionary objectForKey:kProgramItemsKey];
	NSArray *headersArray = (NSArray *)[textDictionary objectForKey:kHeaderTitleKey];
	
	NSString *headerString = [NSString stringWithFormat:@"Fra: %@",[headersArray objectAtIndex:currentIndex]];
	
	return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[timesArray objectAtIndex:currentIndex],[itemsArray objectAtIndex:currentIndex],headerString,nil] 
									   forKeys:[NSArray arrayWithObjects:kProgramTimesKey,kProgramItemsKey,kHeaderTitleKey,nil]];
}

@end
