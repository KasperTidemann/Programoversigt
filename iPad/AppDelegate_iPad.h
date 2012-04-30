//
//  AppDelegate_iPad.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <stdlib.h>

@class GenericGenerator;
@class OptionsViewController;
@class DetailViewController;
@class MeehoWebviewController;

@interface AppDelegate_iPad : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIImageView *generatorIconView;
	UISplitViewController *splitViewController;
	UIButton *typeButton;
	UIButton *randomButton;
    UIButton *nextButton;
    UIButton *prevButton;
    UIButton *mandrilButton;
    UIButton *gatnewsButton;
    UIButton *nameButton;
    UIButton *eroticButton;
    NSArray *generatorArray;
    NSArray *iconButtonArray;
    NSUInteger currentGeneratorInt;
	OptionsViewController *optionsViewController;
	DetailViewController *detailViewController;
	MeehoWebviewController *meehoWebViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIImageView *generatorIconView;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet UIButton *typeButton;
@property (nonatomic, retain) IBOutlet UIButton *randomButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *mandrilButton;
@property (nonatomic, retain) IBOutlet UIButton *gatnewsButton;
@property (nonatomic, retain) IBOutlet UIButton *nameButton;
@property (nonatomic, retain) IBOutlet UIButton *eroticButton;
@property (nonatomic, retain) IBOutlet OptionsViewController *optionsViewController;
@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) IBOutlet MeehoWebviewController *meehoWebViewController;

- (IBAction)changeProgramType:(id)sender;
- (IBAction)generateProgramGuide:(id)sender;
- (IBAction)presentMeehoWebpage;
- (IBAction)dissmissMeehoWebpage;

@end

