//
//  AppDelegate_iPhone.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/10/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProgramGuideTableViewController;
@class GenericGenerator;
@class MeehoWebviewController;

@interface AppDelegate_iPhone : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UIView *mainView;
	UIView *flipView;
	UIImageView *generatorIconView;
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
    UISwipeGestureRecognizer *swipeRecognizer;
	MeehoWebviewController *webviewController;
	ProgramGuideTableViewController *programGuideTableViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *mainView;
@property (nonatomic, retain) IBOutlet UIView *flipView;
@property (nonatomic, retain) IBOutlet UIImageView *generatorIconView;
@property (nonatomic, retain) IBOutlet UIButton *randomButton;
@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *prevButton;
@property (nonatomic, retain) IBOutlet UIButton *mandrilButton;
@property (nonatomic, retain) IBOutlet UIButton *gatnewsButton;
@property (nonatomic, retain) IBOutlet UIButton *nameButton;
@property (nonatomic, retain) IBOutlet UIButton *eroticButton;
@property (nonatomic, retain) IBOutlet MeehoWebviewController *webviewController;
@property (nonatomic, retain) IBOutlet ProgramGuideTableViewController *programGuideTableViewController;

- (IBAction)changeProgramType:(id)sender;
- (IBAction)generateProgramGuide:(id)sender;
- (IBAction)flipViews;
- (IBAction)presentMeehoWebpage;
- (IBAction)dissmissMeehoWebpage;

@end

