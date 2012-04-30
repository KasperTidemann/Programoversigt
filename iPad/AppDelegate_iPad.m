//
//  AppDelegate_iPad.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import "AppDelegate_iPad.h"
#import "NameGenerator.h"
#import "GatNewsGenerator.h"
#import "MandrilGenerator.h"
#import "MaggezEroticGenerator.h"
#import "OptionsViewController.h"
#import "DetailViewController.h"
#import "ProgramGuideTableViewController.h"
#import "MeehoWebviewController.h"

#define ANIMATIONDURATION 0.75

@implementation AppDelegate_iPad

@synthesize window;
@synthesize generatorIconView;
@synthesize splitViewController;
@synthesize typeButton;
@synthesize randomButton;
@synthesize nextButton;
@synthesize prevButton;
@synthesize mandrilButton;
@synthesize gatnewsButton;
@synthesize nameButton;
@synthesize eroticButton;
@synthesize optionsViewController;
@synthesize detailViewController;
@synthesize meehoWebViewController;

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
	
	[self.window addSubview:splitViewController.view];
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
    ProgramGuideTableViewController *pgtvCtrl = detailViewController.programGuideTableViewController;
    
    if (sender == nextButton) {
        [pgtvCtrl loadProgram:[curGen nextProgram]];
    } else if (sender == prevButton) {
        [pgtvCtrl loadProgram:[curGen prevProgram]];
    } else if (sender == randomButton) {
        [pgtvCtrl loadProgram:[curGen randomProgram]];
    } else {
        [pgtvCtrl loadProgram:[curGen currentProgram]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}

- (IBAction)presentMeehoWebpage {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATIONDURATION];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.window cache:YES];
	[splitViewController.view removeFromSuperview];
	[self.window addSubview:meehoWebViewController.view];
	[UIView commitAnimations];
}

- (IBAction)dissmissMeehoWebpage {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:ANIMATIONDURATION];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.window cache:YES];
	[meehoWebViewController.view removeFromSuperview];
	[self.window addSubview:splitViewController.view];
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[generatorArray release];
    [iconButtonArray release];
    [window release];
	[generatorIconView release];
	[splitViewController release];
	[typeButton release];
	[randomButton release];
    [nextButton release];
    [prevButton release];
    [mandrilButton release];
    [gatnewsButton release];
    [nameButton release];
    [eroticButton release];
	[optionsViewController release];
	[detailViewController release];
	[meehoWebViewController release];
    [super dealloc];
}


@end
