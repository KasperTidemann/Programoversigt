    //
//  MeehoWebviewController.m
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/17/10.
//  Copyright 2010 Technical University of Denmark. All rights reserved.
//

#import "MeehoWebviewController.h"


@implementation MeehoWebviewController

@synthesize webView;

- (void)viewDidLoad {
	[super viewDidLoad];
	
	for (UIView *v in self.view.subviews) {
		if ([v isKindOfClass:[UINavigationBar class]]) {
			[(UINavigationBar *)v setTintColor:[UIColor colorWithRed:0.122f green:0.392f blue:0.581f alpha:1.0f]];
		}
	}
	
	self.webView.scalesPageToFit = YES;
	self.webView.dataDetectorTypes = UIDataDetectorTypeNone;
}

- (void)viewWillAppear:(BOOL)animated {
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.meeho.dk/"]]];
	[super viewWillAppear:(BOOL)animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? YES : NO;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)wView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)wView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(UIWebView *)wView didFailLoadWithError:(NSError *)error {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	[webView release];
	[super dealloc];
}

@end
