//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "WebViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation WebViewController

@synthesize webView;
@synthesize toolbar;
@synthesize backButton;
@synthesize forwardButton;
@synthesize reloadButton;

- (void)refreshButtons {
	[backButton setEnabled:[self.webView canGoBack]];
	[forwardButton setEnabled:[self.webView canGoForward]];
	
	if ([self.webView isLoading]) {
		reloadButton.image = [UIImage imageNamed:@"delete.png"];
	} else {
		reloadButton.image = [UIImage imageNamed:@"reload.png"];
	}

}

- (void)viewDidLoad {
	[self refreshButtons];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self refreshButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self refreshButtons];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"expected:%d, got:%d", UIWebViewNavigationTypeLinkClicked, navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[self.webView loadRequest:request];
	}
	
	return YES;
}

- (IBAction) reloadButtonPush:(id)sender {
	if ([self.webView isLoading]) {
		[self.webView stopLoading];
	} else {
		[self.webView reload];
	}

	[self refreshButtons];
}

- (IBAction) backButtonPush:(id)sender {
	[self.webView goBack];
	[self refreshButtons];
}

- (IBAction) forwardButtonPush:(id)sender {
	[self.webView goForward];
	[self refreshButtons];
}

- (IBAction) actionButtonPush:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Copy Link", @"Open In Safari", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:self.webView]; // show from our table view (pops up in the middle of the table)
	[actionSheet release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate business

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"buttonIndex %i", buttonIndex);
	
	if (buttonIndex == 0) {
		[[UIPasteboard generalPasteboard] setValue:[self.webView.request.URL absoluteString] 
								 forPasteboardType:(NSString*)kUTTypeUTF8PlainText];
	} else if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:self.webView.request.URL];
	}
}

@end

