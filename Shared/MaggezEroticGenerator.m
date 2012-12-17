//
//  MaggezEroticGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 2/12/12.
//  Copyright (c) 2012 Technical University of Denmark. All rights reserved.
//

#import "MaggezEroticGenerator.h"

//special type strings
static NSString * const R = @"r";
static NSString * const S = @"s";
static NSString * const AF = @" af";
static NSString * const UD = @" ud";
static NSString * const DU = @" du";
static NSString * const DIN = @" din";
static NSString * const I = @" i";
static NSString * const IKKE = @" ikke";
static NSString * const MAASKE = @" måske";
static NSString * const MIN = @" min";
static NSString * const MIG = @" mig";
static NSString * const OG = @" og";
static NSString * const TIL = @" til";
static NSString * const AAH = @" ååååååååh";

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
static NSString * const FORCE_I = @"force_i";
static NSString * const FORCE_F = @"force_f";
static NSString * const FORCEPLU = @"forceplu";
static NSString * const CAPITALIZE = @"capitalize";


@interface MaggezEroticGenerator ()

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender;

@end

@implementation MaggezEroticGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_maggez_plain_beta"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_maggez_text_beta"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_maggez_hilight_beta"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_erotic"] retain];
        hasNextPrevButtons = NO;
        
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:25];
		
		NSArray *fileArray = [NSArray arrayWithObjects:
                              @"mag_aabning_i",
                              @"mag_aabning_f",
                              @"mag_aabning_tillaegsord_i",
                              @"mag_aabning_tillaegsord_f",
                              @"mag_aabning_tillaegsord_bestemt",
                              @"mag_fallos_f",
                              @"mag_fallos_i",
                              @"mag_indfoer",
                              @"mag_kaldenavn",
                              @"mag_navngiv",
                              @"mag_fallos_tillaegsord_f",
                              @"mag_fallos_tillaegsord_i",
                              @"mag_fallos_tillaegsord_bestemt",
                              @"mag_person",
                              @"mag_person_tillaegsord",
                              @"mag_person_tillaegsord_bestemt",
                              @"mag_perversion",
                              @"mag_soeger",
                              @"mag_verber_bydeform",
                              nil];
		
		for (NSString *filename in fileArray) {
			[tempDic setObject:[self arrayFromFile:[mainBundle pathForResource:filename ofType:@"txt"]] forKey:filename];
		}
		
		textDictionary = [[NSDictionary alloc] initWithDictionary:tempDic];
		
		//make item classes
        itemClasses = [[NSArray alloc] initWithObjects:
                       [NSArray arrayWithObjects:EXCLSTART,AAH,COMMA,EXCLEND,@"indfoer",DIN,EXCLSTART,@"fallos_tillaegsord_bestemt",EXCLEND,@"fallos",I,RANDOM,MIN,EXCLSTART,@"aabning_tillaegsord_bestemt",EXCLEND,@"aabning",OG,@"navngiv",MIG,@"kaldenavn",EXCLAMATIONPOINT,nil],
                       [NSArray arrayWithObjects:@"person_tillaegsord",@"person",@"soeger",@"person_tillaegsord",@"person",TIL,@"perversion",PERIOD,nil],
                       [NSArray arrayWithObjects:FORCE_F,@"verber_bydeform",MIG,COMMA,DIN,@"person_tillaegsord_bestemt",@"person",EXCLAMATIONPOINT,nil],
                       nil];
		
	}
	
	return self;
}

- (NSString *)itemString {
	//determine the random item class
    NSInteger classNumber = arc4random() % [itemClasses count];
    NSArray *itemClass = [itemClasses objectAtIndex:classNumber];
	
	//the item string is made
	NSString *itemString = nil;
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
					itemString = (itemString) ? [itemString stringByAppendingFormat:@"%@",subString] : subString;
					concat = NO;
				} else {
					itemString = (itemString) ? [itemString stringByAppendingFormat:@" %@",subString] : subString;
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
					
				} else if (FORCE_I == type) {
					gender = @"_i";
					
				} else if (FORCE_F == type) {
					gender = @"_f";
					
				} else if (FORCEPLU == type) {
					count = @"_fler";
					
				} else if (type == DIN) {
                    itemString = ([gender isEqualToString:@"_i"]) ? [itemString stringByAppendingString:@" dit"] : [itemString stringByAppendingString:@" din"];
                    
                } else if (type == MIN) {
                    itemString = ([gender isEqualToString:@"_i"]) ? [itemString stringByAppendingString:@" mit"] : [itemString stringByAppendingString:@" min"];
                    
                } else {
					itemString = (itemString) ? [itemString stringByAppendingFormat:@"%@",type] : type;
				}
			}
		}
		
		if (type == EXCLAMATIONPOINT || type == PERIOD || type == QUESTIONMARK) {
			capitalize = YES;
		}
	}
	
	//trim out whitespace characters, capitalize first letter of string and return it
	itemString = [itemString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return [NSString stringWithFormat:@"%@%@",[[itemString substringToIndex:1] uppercaseString], [itemString substringFromIndex:1]];
}

- (NSString *)headerString {
    return @"Maggez' tilnærmelser:";
}

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender {
	NSArray *textArray;
	int randIndex;
    
    textArray = (NSArray *)[textDictionary objectForKey:[@"mag_" stringByAppendingFormat:@"%@%@", type, count]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"mag_" stringByAppendingFormat:@"%@%@", type, gender]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"mag_" stringByAppendingFormat:@"%@", type]];
    
    if (textArray == nil)
        return nil;
	
	//an array of the given type was found
	randIndex = arc4random() % [textArray count];
	return (NSString *)[textArray objectAtIndex:randIndex];
}

- (NSDictionary *)randomProgram {
	
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:3];
	
    // generate item
    NSMutableArray *itemsArr = [NSMutableArray arrayWithObject:[self itemString]];
	[tempDic setObject:itemsArr forKey:kProgramItemsKey];
    
    // generate header
	[tempDic setObject:[self headerString] forKey:kHeaderTitleKey];
	
	return [NSDictionary dictionaryWithDictionary:tempDic];
}

- (void)dealloc {
	[itemClasses release];
	[super dealloc];
}

@end
