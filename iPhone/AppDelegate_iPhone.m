//
//  AppDelegate_iPhone.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import "AppDelegate_iPhone.h"
#import "ProgramGuideTableViewController.h"
#import "NameGenerator.h"
#import "GatNewsGenerator.h"
#import "MandrilGenerator.h"
#import "MaggezEroticGenerator.h"
#import "MeehoWebviewController.h"

#define ANIMATIONDURATION 0.75

@implementation AppDelegate_iPhone

@synthesize window;
@synthesize mainView;
@synthesize flipView;
@synthesize generatorIconView;
@synthesize randomButton;
@synthesize nextButton;
@synthesize prevButton;
@synthesize mandrilButton;
@synthesize gatnewsButton;
@synthesize nameButton;
@synthesize eroticButton;
@synthesize webviewController;
@synthesize programGuideTableViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    generatorArray = [[NSArray arrayWithObjects:
                       [MandrilGenerator new],
                       [GatNewsGenerator new],
                       [NameGenerator new],
                       [MaggezEroticGenerator new],
                       nil] retain];
    
    iconButtonArray = [[NSArray arrayWithObjects:
                        mandrilButton,
                        gatnewsButton,
                        nameButton,
                        eroticButton,
                        nil] retain];
    
    for (NSUInteger i = 0; i < iconButtonArray.count; i++) {
        [(UIButton *)[iconButtonArray objectAtIndex:i] setTag:i];         
    }
    
    // check for previously chosen generator
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger lastUsedGenerator = [userDefaults integerForKey:@"ProgramoversigtAppLastUsedGenerator"];
    
    currentGeneratorInt = (lastUsedGenerator < [generatorArray count]) ? lastUsedGenerator : 0;
    
    //set up swipe recognizer
    swipeRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(flipViews)] retain];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRecognizer.numberOfTouchesRequired = 1;
    [self.mainView addGestureRecognizer:swipeRecognizer];
    
	//set up views
	mainView.frame = [[UIScreen mainScreen] applicationFrame];
	flipView.frame = [[UIScreen mainScreen] applicationFrame];
	webviewController.view.frame = [[UIScreen mainScreen] applicationFrame];
	
	[self.window addSubview:mainView];
    [self.window makeKeyAndVisible];
    [self changeProgramType:self];
    return YES;
}

#pragma mark -
#pragma mark Button methods

- (IBAction)changeProgramType:(id)sender {
    GenericGenerator *curGen = [generatorArray objectAtIndex:currentGeneratorInt];
    GenericGenerator *lastGen = [generatorArray objectAtIndex:currentGeneratorInt];
    UIButton *curBut = [iconButtonArray objectAtIndex:currentGeneratorInt];
    UIButton *lastBut = [iconButtonArray objectAtIndex:currentGeneratorInt];
    
    if ([sender isKindOfClass:[UIView class]]) {
        NSInteger genIndex = [(UIView *)sender tag];

        lastGen = [generatorArray objectAtIndex:currentGeneratorInt];
        lastBut = [iconButtonArray objectAtIndex:currentGeneratorInt];
        
        currentGeneratorInt = (genIndex < [generatorArray count]) ? genIndex : 0;
        curGen = [generatorArray objectAtIndex:currentGeneratorInt];
        curBut = [iconButtonArray objectAtIndex:currentGeneratorInt];
        
        // save selected generator
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger:genIndex forKey:@"ProgramoversigtAppLastUsedGenerator"];
    }
	
    // set button images
    [lastBut setImage:lastGen.iconTextImage forState:UIControlStateNormal];
    [curBut setImage:curGen.iconHighlightedTextImage forState:UIControlStateNormal];
    
    nextButton.hidden = !curGen.hasNextPrevButtons;
    prevButton.hidden = !curGen.hasNextPrevButtons;
    
    generatorIconView.image = curGen.iconImage;
	[randomButton setImage:curGen.buttonImage forState:UIControlStateNormal];

	[self generateProgramGuide:self];
}

- (IBAction)generateProgramGuide:(id)sender {
    GenericGenerator *curGen = [generatorArray objectAtIndex:currentGeneratorInt];
    
    if (sender == nextButton) {
        [programGuideTableViewController loadProgram:[curGen nextProgram]];
    } else if (sender == prevButton) {
        [programGuideTableViewController loadProgram:[curGen prevProgram]];
    } else if (sender == randomButton) {
        [programGuideTableViewController loadProgram:[curGen randomProgram]];
    } else {
        [programGuideTableViewController loadProgram:[curGen currentProgram]];
    }
}

- (IBAction)flipViews {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATIONDURATION];
	
	if (flipView.superview) {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
		[flipView removeFromSuperview];
        
        [self.mainView addGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	} else {
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
		[self.window addSubview:flipView];
        
        [self.flipView addGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
	}
	[UIView commitAnimations];
}

- (IBAction)presentMeehoWebpage {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATIONDURATION];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
	[self.window addSubview:webviewController.view];
	[UIView commitAnimations];
}

- (IBAction)dissmissMeehoWebpage {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATIONDURATION];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
	[webviewController.view removeFromSuperview];
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [window release];
	[mainView release];
	[flipView release];
	[generatorIconView release];
	[randomButton release];
    [nextButton release];
    [prevButton release];
    [mandrilButton release];
    [gatnewsButton release];
    [nameButton release];
    [eroticButton release];
    [generatorArray release];
    [iconButtonArray release];
    [swipeRecognizer release];
	[webviewController release];
	[programGuideTableViewController release];
    [super dealloc];
}


@end
