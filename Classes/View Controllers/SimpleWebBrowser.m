//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "SimpleWebBrowser.h"
#import "NSObject+KVOBlocks.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface SimpleWebBrowser ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadButton;

- (IBAction)reloadButtonPush:(id)sender;
- (IBAction)backButtonPush:(id)sender;
- (IBAction)forwardButtonPush:(id)sender;
- (IBAction)actionButtonPush:(id)sender;

@end

@implementation SimpleWebBrowser

- (instancetype)initWithURL:(NSURL *)url
{
	self = [super initWithNibName:nil bundle:nil];
	
	if (!self) return nil;
	
	self.url = url;
	
	return self;
}

- (void)setUrl:(NSURL *)url
{
	if ([_url isEqual:url])
		return;
	
	_url = [url copy];
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)setWebView:(UIWebView *)webView
{
	_webView = webView;
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

- (void)viewDidLoad
{
	NSKeyValueObservingOptions options = NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew;
	static void *context = &context;

	[self.webView observeKeyPath:@keypath(self.webView, canGoBack) changeBlock:^(NSDictionary *change) {
		self.backButton.enabled = self.webView.canGoBack;
	}];
//	[self.webView addObserver:self forKeyPath:@keypath(self.webView, canGoBack) options:options context:context];
	[self.webView addObserver:self forKeyPath:@keypath(self.webView, canGoForward) options:options context:context];
	[self.webView addObserver:self forKeyPath:@keypath(self.webView, loading) options:options context:context];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@keypath(self.webView, canGoBack)])
	{
		self.backButton.enabled = self.webView.canGoBack;
	}
	else if ([keyPath isEqualToString:@keypath(self.webView, canGoForward)])
	{
		self.forwardButton.enabled = self.webView.canGoForward;
	}
	else if ([keyPath isEqualToString:@keypath(self.webView, loading)])
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = self.webView.loading;

		NSString *imageName = self.webView.loading ? @"delete.png" : @"reload.png";
		self.reloadButton.image = [UIImage imageNamed:imageName];
		
		self.navigationItem.title = self.webView.loading ? [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] : @"";
	} else {
		
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	[self.webView loadRequest:request];
	
	return YES;
}

- (IBAction) reloadButtonPush:(id)sender
{
	if (self.webView.loading)
	{
		[self.webView stopLoading];
	} else {
		[self.webView reload];
	}
}

- (IBAction) backButtonPush:(id)sender
{
	[self.webView goBack];
}

- (IBAction)forwardButtonPush:(id)sender
{
	[self.webView goForward];
}

- (IBAction)actionButtonPush:(id)sender
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

