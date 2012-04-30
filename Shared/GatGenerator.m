//
//  GatGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/21/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "GatGenerator.h"

//special type strings
static NSString * const R = @"r";
static NSString * const S = @"s";
static NSString * const AF = @" af";
static NSString * const UD = @" ud";
static NSString * const DU = @" du";
static NSString * const IKKE = @" ikke";
static NSString * const MAASKE = @" måske";
static NSString * const SKIFTE = @" skifte";
static NSString * const NAVNTIL = @" navn til";
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


@interface GatGenerator ()

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender;

@end

@implementation GatGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_gatgen"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_gatgen"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_gatgen"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_gatgen"] retain];
        hasNextPrevButtons = NO;
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:25];
		
		NSArray *fileArray = [NSArray arrayWithObjects:
                              @"gat_advarsel",
							  @"gat_antal",
							  @"gat_begrundelser",
							  @"gat_betingelser",
							  @"gat_efternavne",
							  @"gat_egennavne_en",
							  @"gat_egennavne_fler",
							  @"gat_er",
							  @"gat_forholdsord",
							  @"gat_fornavne",
							  @"gat_fortillaegsord",
							  @"gat_forventning",
							  @"gat_handling_navneform",
							  @"gat_handling_nutid",
							  @"gat_handling_nutid_med_forhold",
							  @"gat_maal",
							  @"gat_materiale_f",
							  @"gat_materiale_fler",
							  @"gat_materiale_i",
							  @"gat_materiale_sammensat",
							  @"gat_mellemnavne",
							  @"gat_navneord_f",
							  @"gat_navneord_fler",
							  @"gat_navneord_i",
							  @"gat_negapositiv",
							  @"gat_nutidsverber_med_forhold",
							  @"gat_omstaendighed",
							  @"gat_suffiks",
							  @"gat_tildelinger",
							  @"gat_tillaegsord_f",
							  @"gat_tillaegsord_fler",
							  @"gat_tillaegsord_i",
							  @"gat_verber",nil];
		
		for (NSString *filename in fileArray) {
			[tempDic setObject:[self arrayFromFile:[mainBundle pathForResource:filename ofType:@"txt"]] forKey:filename];
		}
		
		textDictionary = [[NSDictionary alloc] initWithDictionary:tempDic];
		
		//make item classes
		itemClasses = [[NSArray alloc] initWithObjects:
                       [NSArray arrayWithObjects:@"materiale",@"omstaendighed",QUESTIONMARK,@"negapositiv",EXCLAMATIONPOINT,nil],
					   [NSArray arrayWithObjects:@"advarsel",EXCLAMATIONPOINT,EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",EXCLAMATIONPOINT,nil],
					   [NSArray arrayWithObjects:@"advarsel",EXCLAMATIONPOINT,@"egennavne",@"verber",S,EXCLAMATIONPOINT,nil],
					   [NSArray arrayWithObjects:@"egennavne_en",CONCAT,@"suffiks",@"forventning",EXCLSTART,@"negapositiv",EXCLEND,@"handling_navneform",EXCLSTART,@"omstaendighed",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne_en",EXCLSTART,CONCAT,@"suffiks",EXCLEND,EXCLSTART,@"handling_nutid",EXCLSWITCH,@"handling_nutid_med_forhold",@"fortillaegsord",@"tillaegsord",@"navneord",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"materiale_sammensat",CONCAT,@"suffiks",@"verber",S,@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"antal",EXCLSTART,@"navneord_fler",EXCLEND,UD,AF,@"antal",@"forventning",EXCLSTART,IKKE,EXCLEND,@"handling_navneform",EXCLSTART,COMMA,@"begrundelser",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"forventning",EXCLSTART,IKKE,EXCLEND,@"handling_navneform",EXCLSTART,COMMA,@"begrundelser",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"antal",UD,AF,@"antal",@"navneord_fler",@"verber",S,EXCLSTART,IKKE,EXCLEND,EXCLSTART,@"omstaendighed",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"tildelinger",@"antal",@"navneord_fler",@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"verber",R,EXCLSTART,@"negapositiv",EXCLEND,@"antal",@"navneord_fler",@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"navneord",@"tildelinger",RANDOM,@"egennavne",GENITIV,RANDOM,@"materiale",PERIOD,nil],
					   [NSArray arrayWithObjects:EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",@"verber",S,AF,RANDOM,@"egennavne",PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"verber",S,@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"betingelser",@"antal",FORCEPLU,EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",EXCLSTART,IKKE,EXCLEND,@"verber",R,@"egennavne",@"forventning",RANDOM,@"materiale",@"verber",@"materiale_sammensat",CONCAT,@"navneord",PERIOD,nil],
					   [NSArray arrayWithObjects:@"antal",UD,AF,@"antal",@"verber",R,@"tillaegsord",REPEAT,@"materiale_sammensat",CONCAT,@"navneord",@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"materiale_sammensat",CONCAT,@"navneord",@"forventning",@"verber",S,AF,RANDOM,@"egennavne",@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"antal",FORCEPLU,@"navneord",AF,FORCESIN,@"materiale",@"verber",S,@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"forventning",@"antal",@"maal",@"materiale",EXCLSTART,IKKE,EXCLEND,@"verber",S,QUESTIONMARK,nil],
					   [NSArray arrayWithObjects:@"forventning",@"egennavne",@"verber",RANDOM,@"materiale",QUESTIONMARK,nil],
					   [NSArray arrayWithObjects:@"tillaegsord",@"materiale",@"verber",S,EXCLAMATIONPOINT,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"nutidsverber_med_forhold",EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",PERIOD,nil],
					   [NSArray arrayWithObjects:DU,@"forventning",SKIFTE,NAVNTIL,@"fornavne",EXCLSTART,@"mellemnavne",@"efternavne",EXCLSWITCH,@"efternavne",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"betingelser",@"materiale",@"verber",S,FORCESIN,SKIFTE,R,@"egennavne",NAVNTIL,@"fornavne",EXCLSTART,@"mellemnavne",@"efternavne",EXCLSWITCH,@"efternavne",EXCLEND,PERIOD,nil],
					   [NSArray arrayWithObjects:@"tillaegsord",@"navneord",@"handling_nutid_med_forhold",RANDOM,@"egennavne",PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"handling_nutid",@"omstaendighed",PERIOD,nil],
					   [NSArray arrayWithObjects:@"egennavne",@"handling_nutid_med_forhold",RANDOM,@"materiale_sammensat",CONCAT,@"navneord",PERIOD,nil],
					   [NSArray arrayWithObjects:@"navneord",AF,@"materiale",@"verber",S,PERIOD,nil],
					   nil];
		
		sentenceType = [itemClasses count];
	}
	
	return self;
}

- (NSString *)itemString {
	//determine the random item class
	int classNumber = (sentenceType == [itemClasses count]) ? arc4random() % [itemClasses count] : sentenceType;
	
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
	return (arc4random() % 100 == 0) ? @"Janssons fristelser:" : @"Gatmans tilfældigheder:";
}

- (NSString *)randTextOfType:(NSString *)type count:(NSString *)count gender:(NSString *)gender {
	NSArray *textArray;
	int randIndex;
    
    textArray = (NSArray *)[textDictionary objectForKey:[@"gat_" stringByAppendingFormat:@"%@%@", type, count]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"gat_" stringByAppendingFormat:@"%@%@", type, gender]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"gat_" stringByAppendingFormat:@"%@", type]];
    
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
