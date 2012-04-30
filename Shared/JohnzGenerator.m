//
//  JohnzGenerator.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/15/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import "JohnzGenerator.h"

@implementation JohnzGenerator

- (id)init {
	if (self == [super init]) {
		iconImage = [[UIImage imageNamed:@"icon_johnz"] retain];
        iconTextImage = [[UIImage imageNamed:@"icon_johnz"] retain];
        iconHighlightedTextImage = [[UIImage imageNamed:@"icon_johnz"] retain];
		buttonImage = [[UIImage imageNamed:@"generate_button_johnz"] retain];
        hasNextPrevButtons = NO;
		
		NSBundle *mainBundle = [NSBundle mainBundle];
		
		NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithCapacity:25];
		
		NSArray *fileArray = [NSArray arrayWithObjects:@"egennavne",
							  @"klasse1mellemled",
							  @"klasse1slutled",
							  @"klasse2mellemled",
							  @"klasse3mellemled",
							  @"klasse3mellemled2",
							  @"klasse3slutled",
							  @"klasse3startled",
							  @"klasse4startled",
							  @"klasse5genstande",
							  @"klasse5slutled",
							  @"klasse5startled",
							  @"klasse6mellemled",
							  @"klasse6slutled",
							  @"klasse6startled",
							  @"klasse7mellemled",
							  @"klasse7slutled",
							  @"klasse8mellemled",
							  @"klasse8slutled",
							  @"klasse8startled",
							  @"klasse8startled2",
							  @"klasse9mellemled",
							  @"klasse9slutled",
							  @"klasse9startled",
							  @"navneord",
							  @"nutidsverber",nil];
		
		for (NSString *filename in fileArray) {
			[tempDic setObject:[self arrayFromFile:[mainBundle pathForResource:filename ofType:@"txt"]] forKey:filename];
		}
		
		textDictionary = [[NSDictionary alloc] initWithDictionary:tempDic];
	}
	
	return self;
}

- (NSString *)itemString {
	//determine the random truth string class
	int stringClass = arc4random() % 9;
	int stringSubClass = arc4random() % 6;
	
	NSArray *stringStructure;
	
	switch (stringClass) {
		case 0:
			//fact #1
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"egennavne",@"klasse1mellemled",@"klasse1slutled",@".",nil] :
			[NSArray arrayWithObjects:@"navneord",@"klasse1mellemled",@"klasse1slutled",@".",nil];
			break;
		case 1:
			//fact #2
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"navneord",@"klasse2mellemled",@"egennavne",@".",nil] :
			[NSArray arrayWithObjects:@"egennavne",@"klasse2mellemled",@"navneord",@".",nil];
			break;
		case 2:
			//condition
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"klasse3startled",@"navneord",@"klasse3mellemled",@"klasse3mellemled2",@"egennavne",@"klasse3slutled",@".",nil] :
			[NSArray arrayWithObjects:@"klasse3startled",@"egennavne",@"klasse3mellemled",@"klasse3mellemled2",@"navneord",@"klasse3slutled",@".",nil];
			break;
		case 3:
			//prophecy
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"klasse4startled",@"klasse3mellemled2",@"navneord",@"klasse3slutled",@".",nil] :
			[NSArray arrayWithObjects:@"klasse4startled",@"klasse3mellemled2",@"egennavne",@"klasse3slutled",@".",nil];
			break;
		case 4:
			//fact #3
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"navneord",@"klasse5startled",@"klasse5genstande",@".",nil] :
			[NSArray arrayWithObjects:@"egennavne",@"klasse5startled",@"klasse5genstande",@".",nil];
			break;
		case 5:
			//warning
			switch (stringSubClass % 3) {
				case 0:
					stringStructure = [NSArray arrayWithObjects:@"klasse6startled",@"klasse6mellemled",@"klasse6slutled",@"!",nil];
					break;
				case 1:
					stringStructure = [NSArray arrayWithObjects:@"navneord",@"klasse6mellemled",@"klasse6slutled",@"!",nil];
					break;	
				default:
					stringStructure = [NSArray arrayWithObjects:@"egennavne",@"klasse6mellemled",@"klasse6slutled",@"!",nil];
					break;
			}
			break;
		case 6:
			//fact #4
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"navneord",@"nutidsverber",@"klasse7mellemled",@"klasse7slutled",@"!",nil] :
			[NSArray arrayWithObjects:@"egennavne",@"nutidsverber",@"klasse7mellemled",@"klasse7slutled",@"!",nil];
			break;
		case 7:
			//rule
			stringStructure = (stringSubClass % 2 == 0) ? [NSArray arrayWithObjects:@"navneord",@"klasse8startled",@"klasse8startled2",@"klasse8mellemled",@",",@"klasse8slutled",@".",nil] :
			[NSArray arrayWithObjects:@"egennavne",@"klasse8startled",@"klasse8startled2",@"klasse8mellemled",@",",@"klasse8slutled",@".",nil];
			break;
		default:
			//punishment
			stringStructure = [NSArray arrayWithObjects:@"klasse9startled",@"klasse9mellemled",@"klasse9slutled",@"!",nil];
			break;
	}
	
	//the truth string is made
	NSString *stringString = nil;
	NSArray *termArr = nil;
	
	for (NSString *s in stringStructure) {
		termArr = (NSArray *)[textDictionary objectForKey:s];
		
		if (termArr) {
			int randIndex = arc4random() % [termArr count];
			stringString = (stringString) ? [stringString stringByAppendingFormat:@" %@",[termArr objectAtIndex:randIndex]] : [termArr objectAtIndex:randIndex];
		} else {
			stringString = (stringString) ? [stringString stringByAppendingFormat:@"%@",s] : s;
		}
	}
	
	//capitalize first letter of truth string and return it
	return [NSString stringWithFormat:@"%@%@",[[stringString substringToIndex:1] uppercaseString], [stringString substringFromIndex:1]];
}

- (NSString *)headerString {
	//override
	return @"Johnz' sandheder:";
}

@end
