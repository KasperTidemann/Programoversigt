//
//  MeehoWebviewController.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/17/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MeehoWebviewController : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
