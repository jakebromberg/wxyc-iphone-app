//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "WebViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface WebViewController ()

@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadButton;

@end

@implementation WebViewController

- (void)loadURL:(NSURL *)url
{
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)refreshButtons
{
	self.backButton.enabled = self.webView.canGoBack;
	self.forwardButton.enabled = self.webView.canGoForward;
	
	if (self.webView.loading) {
		self.reloadButton.image = [UIImage imageNamed:@"delete.png"];
	} else {
		self.reloadButton.image = [UIImage imageNamed:@"reload.png"];
	}
}

- (void)viewDidLoad
{
	[self refreshButtons];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self refreshButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[self refreshButtons];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"expected:%d, got:%d", UIWebViewNavigationTypeLinkClicked, navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		[self.webView loadRequest:request];
	}
	
	return YES;
}

- (IBAction) reloadButtonPush:(id)sender
{
	if (self.webView.loading) {
		[self.webView stopLoading];
	} else {
		[self.webView reload];
	}

	[self refreshButtons];
}

- (IBAction) backButtonPush:(id)sender
{
	[self.webView goBack];
	[self refreshButtons];
}

- (IBAction) forwardButtonPush:(id)sender
{
	[self.webView goForward];
	[self refreshButtons];
}

- (IBAction) actionButtonPush:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle:nil
													otherButtonTitles:@"Copy Link", @"Open In Safari", nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[actionSheet showInView:self.webView]; // show from our table view (pops up in the middle of the table)
}

- (IBAction)closePush:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate business

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"buttonIndex %i", buttonIndex);
	
	if (buttonIndex == 0) {
		[[UIPasteboard generalPasteboard] setValue:[self.webView.request.URL absoluteString] 
								 forPasteboardType:(NSString *)kUTTypeUTF8PlainText];
	} else if (buttonIndex == 1) {
		[[UIApplication sharedApplication] openURL:self.webView.request.URL];
	}
}

@end

