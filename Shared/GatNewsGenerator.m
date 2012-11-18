//
//  GatNewsGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 2/11/12.
//  Copyright (c) 2012 Technical University of Denmark. All rights reserved.
//

#import "GatNewsGenerator.h"

//special type strings
static NSString * const R = @"r";
static NSString * const S = @"s";
static NSString * const AF = @" af";
static NSString * const HAR = @" har";
static NSString * const OG = @" og";
static NSString * const UD = @" ud";
static NSString * const IKKE = @" ikke";
static NSString * const MAASKE = @" måske";

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


@interface GatNewsGenerator ()

- (NSString *)randTextOfType:(NSString *)type parameter:(NSString *)param;

@end

@implementation GatNewsGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_gatnews_plain"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_gatnews_text"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_gatnews_hilight"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_gatnews"] retain];
        hasNextPrevButtons = NO;
        isBreaking = NO;
        		
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:25];
		
		NSArray *fileArray = [NSArray arrayWithObjects:@"gat_advarsel",
							  @"gat_antal",
							  @"gat_begrundelser",
							  @"gat_betingelser",
                              @"gat_debat",
							  @"gat_egennavne_f",
							  @"gat_egennavne_fler",
                              @"gat_egennavne_i",
							  @"gat_er",
                              @"gat_fra_kilde",
							  @"gat_forholdsord",
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
							  @"gat_navneord_f",
							  @"gat_navneord_fler",
							  @"gat_navneord_i",
							  @"gat_negapositiv",
							  @"gat_nutidsverber_med_forhold",
							  @"gat_omstaendighed",
                              @"gat_praefiks",
							  @"gat_suffiks",
							  @"gat_tildelinger",
							  @"gat_tillaegsord_f",
							  @"gat_tillaegsord_fler",
							  @"gat_tillaegsord_i",
                              @"gat_tillaegsord-praefiks",
							  @"gat_verber_bydeform",
                              @"gat_verber_datid",
                              @"gat_verber_grundform",
                              @"gat_vs",nil];
		
		for (NSString *filename in fileArray) {
			[tempDic setObject:[self arrayFromFile:[mainBundle pathForResource:filename ofType:@"txt"]] forKey:filename];
		}
		
		textDictionary = [[NSDictionary alloc] initWithDictionary:tempDic];
		
		//make item classes
        newsItemClasses = [[NSArray alloc] initWithObjects:
                           [NSArray arrayWithObjects:@"debat",FORCESIN,@"egennavne",@"vs",@"praefiks",CONCAT,@"navneord",EXCLSTART,PERIOD,EXCLSWITCH,QUESTIONMARK,EXCLEND,nil],
                           [NSArray arrayWithObjects:@"forventning",EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",@"navneord",@"handling_navneform",QUESTIONMARK,nil],
                           [NSArray arrayWithObjects:@"fra_kilde",EXCLSTART,@"egennavne",EXCLSWITCH,@"navneord",EXCLEND,@"er",@"fortillaegsord",@"tillaegsord",PERIOD,nil],
                           [NSArray arrayWithObjects:@"fra_kilde",@"verber_bydeform",@"egennavne",PERIOD,nil],
                           [NSArray arrayWithObjects:@"fra_kilde",@"praefiks",CONCAT,@"materiale",EXCLSTART,HAR,@"negapositiv",@"verber_datid",EXCLSWITCH,@"verber_grundform",R,@"negapositiv",EXCLEND,FORCESIN,@"egennavne",PERIOD,nil],
                           [NSArray arrayWithObjects:@"praefiks",CONCAT,@"materiale",@"verber_grundform",S,PERIOD,nil],
                           [NSArray arrayWithObjects:@"fra_kilde",@"praefiks",CONCAT,@"navneord",EXCLSTART,HAR,@"verber_datid",EXCLSWITCH,@"verber_grundform",R,EXCLEND,FORCESIN,@"egennavne",PERIOD,nil],
                           [NSArray arrayWithObjects:@"debat",@"navneord",@"vs",RANDOM,@"navneord",QUESTIONMARK,nil],
                           [NSArray arrayWithObjects:@"navneord",@"vs",RANDOM,@"navneord",EXCLAMATIONPOINT,nil],
                           [NSArray arrayWithObjects:@"fra_kilde",@"antal",UD,AF,@"antal",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"materiale_sammensat",CONCAT,@"suffiks",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"verber_grundform",S,PERIOD,nil],
                           [NSArray arrayWithObjects:@"materiale",@"omstaendighed",QUESTIONMARK,@"negapositiv",EXCLAMATIONPOINT,nil],
                           [NSArray arrayWithObjects:FORCESIN,@"egennavne_f",CONCAT,@"suffiks",@"forventning",EXCLSTART,@"negapositiv",EXCLEND,@"handling_navneform",EXCLSTART,@"omstaendighed",EXCLEND,PERIOD,nil],
                           [NSArray arrayWithObjects:FORCESIN,@"egennavne_f",EXCLSTART,CONCAT,@"suffiks",EXCLEND,EXCLSTART,@"handling_nutid",EXCLSWITCH,@"handling_nutid_med_forhold",@"fortillaegsord",RANDOM,@"tillaegsord",@"navneord",EXCLEND,PERIOD,nil],
                           [NSArray arrayWithObjects:@"antal",EXCLSTART,@"navneord_fler",EXCLEND,UD,AF,@"antal",@"forventning",EXCLSTART,IKKE,EXCLEND,@"handling_navneform",EXCLSTART,COMMA,@"begrundelser",EXCLEND,PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"forventning",EXCLSTART,IKKE,EXCLEND,@"handling_navneform",EXCLSTART,COMMA,@"begrundelser",EXCLEND,PERIOD,nil],
                           [NSArray arrayWithObjects:@"antal",UD,AF,@"antal",@"navneord_fler",@"verber_grundform",S,EXCLSTART,IKKE,EXCLEND,EXCLSTART,@"omstaendighed",EXCLEND,PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"tildelinger",@"navneord",PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"verber_grundform",R,@"antal",@"navneord_fler",@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",@"verber_grundform",S,AF,RANDOM,@"egennavne",PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"antal",UD,AF,@"antal",EXCLSTART,HAR,@"verber_datid",EXCLSWITCH,@"verber_grundform",R,EXCLEND,EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",REPEAT,@"navneord",@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"materiale_sammensat",CONCAT,@"navneord",@"forventning",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"antal",FORCEPLU,@"navneord",AF,FORCESIN,@"materiale",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"forventning",@"egennavne",@"verber_grundform",RANDOM,@"materiale",QUESTIONMARK,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"nutidsverber_med_forhold",EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",PERIOD,nil],
                           [NSArray arrayWithObjects:EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",@"navneord",@"handling_nutid_med_forhold",RANDOM,@"egennavne",PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"handling_nutid",@"omstaendighed",PERIOD,nil],
                           [NSArray arrayWithObjects:@"egennavne",@"handling_nutid_med_forhold",RANDOM,@"materiale_sammensat",CONCAT,@"navneord",PERIOD,nil],
                           [NSArray arrayWithObjects:@"navneord",AF,@"materiale",@"verber_grundform",S,PERIOD,nil],
                           nil];
        
        
        breakingItemClasses = [[NSArray alloc] initWithObjects:
                               [NSArray arrayWithObjects:@"advarsel",EXCLAMATIONPOINT,EXCLSTART,@"fortillaegsord",EXCLEND,@"tillaegsord",@"navneord",EXCLAMATIONPOINT,nil],
                               [NSArray arrayWithObjects:@"advarsel",EXCLAMATIONPOINT,@"egennavne",@"verber_grundform",S,EXCLAMATIONPOINT,nil],
                               [NSArray arrayWithObjects:@"egennavne",@"verber_grundform",S,EXCLAMATIONPOINT,nil],
                               [NSArray arrayWithObjects:@"materiale_sammensat",CONCAT,@"suffiks",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                               [NSArray arrayWithObjects:@"antal",UD,AF,@"antal",@"navneord_fler",@"verber_grundform",S,EXCLSTART,IKKE,EXCLEND,EXCLSTART,@"omstaendighed",EXCLEND,EXCLAMATIONPOINT,nil],
                               [NSArray arrayWithObjects:@"egennavne",@"tildelinger",@"navneord",EXCLAMATIONPOINT,nil],                               
                               [NSArray arrayWithObjects:@"egennavne",EXCLSTART,HAR,@"verber_datid",EXCLSWITCH,@"verber_grundform",R,EXCLEND,EXCLSTART,@"negapositiv",EXCLEND,@"antal",@"navneord_fler",@"omstaendighed",PERIOD,nil],
                               [NSArray arrayWithObjects:@"egennavne",GENITIV,RANDOM,@"materiale",@"verber_grundform",S,PERIOD,nil],
                               [NSArray arrayWithObjects:@"egennavne",@"verber_grundform",S,@"omstaendighed",PERIOD,nil],
                               [NSArray arrayWithObjects:EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",@"materiale",@"verber_grundform",S,EXCLAMATIONPOINT,nil],
                               [NSArray arrayWithObjects:EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",@"navneord",@"handling_nutid_med_forhold",RANDOM,@"egennavne",PERIOD,nil],
                               [NSArray arrayWithObjects:EXCLSTART,@"tillaegsord-praefiks",CONCAT,EXCLEND,@"tillaegsord",@"navneord",@"handling_nutid_med_forhold",RANDOM,@"egennavne",PERIOD,nil],
                               [NSArray arrayWithObjects:@"egennavne",@"handling_nutid",@"omstaendighed",PERIOD,nil],
                               [NSArray arrayWithObjects:@"navneord",AF,@"materiale",@"verber_grundform",S,EXCLAMATIONPOINT,nil],
                               nil];
		
	}
	
	return self;
}

- (NSString *)itemString {
	//determine the random item class
    NSInteger classNumber;
    NSArray *itemClass;
    
    if (isBreaking) {
        classNumber = arc4random() % [breakingItemClasses count];
        itemClass = [breakingItemClasses objectAtIndex:classNumber];
    } else {
        classNumber = arc4random() % [newsItemClasses count];
//        classNumber = 14; // use to try out specific sentences
        itemClass = [newsItemClasses objectAtIndex:classNumber];
    }
	
	//the item string is made
	NSString *itemString = @"";
	NSString *subString;
    NSString *param;
    NSInteger randParam = arc4random() % 3;
    if (randParam == 0) {
        param = @"_f";
    } else if (randParam == 1) {
        param = @"_fler";
    } else {
        param = @"_i";
    }
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
            
			subString = [self randTextOfType:type parameter:param];
			
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
                    randParam = arc4random() % 3;
                    if (randParam == 0) {
                        param = @"_f";
                    } else if (randParam == 1) {
                        param = @"_fler";
                    } else {
                        param = @"_i";
                    }
					
				} else if (CONCAT == type) {
					concat = YES;
					
				} else if (REPEAT == type) {
					NSString *lastWord = [[itemString componentsSeparatedByString:@" "] lastObject];
					itemString = [itemString stringByAppendingFormat:@", %@",lastWord];
					
				} else if (FORCESIN == type) {
                    param = (arc4random() % 2 == 0) ? @"_i" : @"_f";
					
				} else if (FORCEPLU == type) {
                    param = @"_fler";
					
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

- (NSString *)timeString {
    NSInteger timeGranularity = 30 / programLength;
    NSString *retString;
    
    if ((arc4random() % 100) == 0) {
        retString = @"13:37";
    } else {
        retString = [NSString stringWithFormat:@"23:%i",curTime+timeGranularity-(arc4random() % 3)-1];
    }
    
    curTime = curTime + timeGranularity;
    
    return retString;
}

- (NSString *)headerString {
    return (isBreaking) ? @"BREAKING NEWS!" : @"I aften i GatNews:";
}

- (NSString *)randTextOfType:(NSString *)type parameter:(NSString *)param {
	NSArray *textArray;
	NSInteger randIndex;
    
    textArray = (NSArray *)[textDictionary objectForKey:[@"gat_" stringByAppendingFormat:@"%@%@", type, param]];
    
    if (textArray == nil)
        textArray = (NSArray *)[textDictionary objectForKey:[@"gat_" stringByAppendingFormat:@"%@", type]];
    
    if (textArray == nil)
        return nil;
	
	//an array of the given type was found
	randIndex = arc4random() % [textArray count];
	return (NSString *)[textArray objectAtIndex:randIndex];
}

- (NSDictionary *)randomProgram {
    
    isBreaking = (arc4random() % 10) == 0 ? YES : NO;
    
    if (isBreaking) {
        programLength = 1;
    } else {
        programLength = (arc4random() % 4) + 4;
    }
	
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:3];
	
    // generate items
    NSMutableArray *itemsArr = [NSMutableArray arrayWithCapacity:programLength];
	for (NSInteger i = 0; i < programLength; i++) {
		[itemsArr addObject:[self itemString]];
		//[NSThread sleepForTimeInterval:0.02f];
	}
	[tempDic setObject:itemsArr forKey:kProgramItemsKey];
    
    if (!isBreaking) {
        curTime = 30;
        
        // generate times
        NSMutableArray *timesArr = [NSMutableArray arrayWithCapacity:programLength];
        for (NSInteger i = 0; i < programLength; i++) {
            [timesArr addObject:[self timeString]];
            [NSThread sleepForTimeInterval:0.02f];
        }
        [tempDic setObject:timesArr forKey:kProgramTimesKey];
    }
    
    // generate header
	[tempDic setObject:[self headerString] forKey:kHeaderTitleKey];
	
	return [NSDictionary dictionaryWithDictionary:tempDic];
}

- (void)dealloc {
	[newsItemClasses release];
    [breakingItemClasses release];
	[super dealloc];
}

@end