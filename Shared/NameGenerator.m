//
//  NameGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 2/13/12.
//  Copyright (c) 2012 Technical University of Denmark. All rights reserved.
//

#import "NameGenerator.h"

//special type strings
static NSString * const MCDJ = @"mcdj";
static NSString * const GENITIV = @"genitiv";
static NSString * const PERIOD = @".";
static NSString * const COMMA = @",";
static NSString * const EXCLAMATIONPOINT = @"!";
static NSString * const QUESTIONMARK = @"?";
static NSString * const RANDOM = @"random";
static NSString * const CONCAT = @"concat";
static NSString * const REPEAT = @"repeat";
static NSString * const EXCLSTART = @"exclstart";
static NSString * const EXCLEND = @"exclend";
static NSString * const EXCLSWITCH = @"exclswitch";
static NSString * const FORCESIN = @"forcesin";
static NSString * const FORCEPLU = @"forceplu";
static NSString * const CAPITALIZE = @"capitalize";
static NSString * const PARANSTART = @"(";
static NSString * const PARANEND = @")";


@interface NameGenerator ()

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender;

@end

@implementation NameGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_kasper_plain_beta"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_kasper_text_beta"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_kasper_hilight_beta"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_name"] retain];
        hasNextPrevButtons = NO;
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:25];
		
		NSArray *fileArray = [NSArray arrayWithObjects:
                              @"name_artist_mcdj_alias",
                              @"name_artist_stednavn",
                              @"name_fornavne",
                              @"name_mellemnavne",
                              @"name_efternavne",
                              @"name_svensk",
							  nil];
		
		for (NSString *filename in fileArray) {
			[tempDic setObject:[self arrayFromFile:[mainBundle pathForResource:filename ofType:@"txt"]] forKey:filename];
		}
		
        programLength = 1;
        
		textDictionary = [[NSDictionary alloc] initWithDictionary:tempDic];
		
		//make item classes
		itemClasses = [[NSArray alloc] initWithObjects:
                       [NSArray arrayWithObjects:MCDJ,@"artist_mcdj_alias",nil],
                       [NSArray arrayWithObjects:MCDJ,@"efternavne",nil],
                       [NSArray arrayWithObjects:MCDJ,@"svensk",nil],
                       [NSArray arrayWithObjects:MCDJ,@"artist_stednavn",nil],
                       [NSArray arrayWithObjects:@"fornavne",EXCLSTART,@"mellemnavne",EXCLEND,@"efternavne",nil],
					   nil];
	}
	
	return self;
}

- (NSString *)itemString {
	//determine the random item class
	int classNumber = 3;//arc4random() % [itemClasses count];
	
	NSArray *itemClass = [itemClasses objectAtIndex:classNumber];
	
	//the item string is made
	NSString *itemString = @"";
	NSString *subString;
	NSString *count = (arc4random() % 2 == 0) ? @"_en" : @"_fler";
	NSString *gender = (arc4random() % 2 == 0) ? @"_i" : @"_f";
	BOOL concat = NO;
	BOOL exclusion = NO;
	BOOL capitalize = NO;
	
	for (NSString *type in itemClass) {
		
		//check first for excluded parts of the item
		if (EXCLSTART == type) {
			exclusion = (arc4random() % 2 == 0) ? NO : YES;
			
		} else if (EXCLEND == type) {
			exclusion = NO;
			
		} else if (EXCLSWITCH == type) {
			exclusion = !exclusion;
			
		} else if (NO == exclusion) {
            
			subString = [self randTextOfType:type count:count gender:gender];
			
			if (subString) {
				subString = (capitalize) ? [NSString stringWithFormat:@"%@%@",[[subString substringToIndex:1] uppercaseString], [subString substringFromIndex:1]] : subString;
				capitalize = NO;
				if (concat) {
					itemString = [itemString stringByAppendingFormat:@"%@",subString];
					concat = NO;
				} else {
					itemString = [itemString stringByAppendingFormat:@" %@",subString];
				}
				
			} else {
				if (GENITIV == type) {
					NSString *lastCharacter = [[itemString substringFromIndex:[itemString length]-1] lowercaseString];
					if ([lastCharacter isEqualToString:@"s"] || [lastCharacter isEqualToString:@"z"] || [lastCharacter isEqualToString:@"x"]) {
						itemString = [itemString stringByAppendingFormat:@"'"];
					} else {
						itemString = [itemString stringByAppendingFormat:@"s"];
					}
					
				} else if (RANDOM == type) {
					count = (arc4random() % 2 == 0) ? @"_en" : @"_fler";
					gender = (arc4random() % 2 == 0) ? @"_i" : @"_f";
					
				} else if (CONCAT == type) {
					concat = YES;
					
				} else if (REPEAT == type) {
					NSString *lastWord = [[itemString componentsSeparatedByString:@" "] lastObject];
					itemString = [itemString stringByAppendingFormat:@", %@",lastWord];
					
				} else if (FORCESIN == type) {
					count = @"_en";
					
				} else if (FORCEPLU == type) {
					count = @"_fler";
					
				} else if (type == MCDJ) {
                    itemString = (arc4random() % 2 == 0) ? [itemString stringByAppendingString:@" MC"] : [itemString stringByAppendingString:@" DJ"];
                    
                } else {
					itemString = [itemString stringByAppendingFormat:@"%@",type];
				}
			}
            
            if (type == EXCLAMATIONPOINT || type == PERIOD || type == QUESTIONMARK) {
                capitalize = YES;
            }
		}
	}
	
	//trim out whitespace characters, capitalize first letter of string and return it
	itemString = [itemString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return [NSString stringWithFormat:@"%@%@",[[itemString substringToIndex:1] uppercaseString], [itemString substringFromIndex:1]];
}

- (NSString *)headerString {
	return @"Dit nye navn:";
}

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender {
	NSArray *textArray;
	int randIndex;
    
    textArray = (NSArray *)[textDictionary objectForKey:[@"name_" stringByAppendingFormat:@"%@%@", type, count]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"name_" stringByAppendingFormat:@"%@%@", type, gender]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"name_" stringByAppendingFormat:@"%@", type]];
    
    if (textArray == nil)
        return nil;
	
	//an array of the given type was found
	randIndex = arc4random() % [textArray count];
	return (NSString *)[textArray objectAtIndex:randIndex];
}

- (void)dealloc {
	[itemClasses release];
	[super dealloc];
}

@end
