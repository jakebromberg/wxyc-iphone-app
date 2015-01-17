//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "SimpleWebBrowser.h"
#import "NSObject+KVOBlocks.h"
#import <MobileCoreServices/UTCoreTypes.h>

typedef NS_ENUM(NSInteger, BrowserPopupLabels) {
	PopupCopyLink,
	PopupOpenInSafari,
	PopupCancel,
	PopupCount
} ;

static NSString * const PopupLabels[PopupCount] = {
	[PopupCopyLink] = @"Copy Link",
	[PopupOpenInSafari] = @"Open In Safari",
	[PopupCancel] = @"Cancel",
};


@interface SimpleWebBrowser ()

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *reloadButton;

- (IBAction)reloadButtonPushed:(id)sender;
- (IBAction)backButtonPush:(id)sender;
- (IBAction)forwardButtonPush:(id)sender;
- (IBAction)actionButtonPush:(id)sender;

@end


@implementation SimpleWebBrowser

- (instancetype)initWithURL:(NSURL *)url
{
	if (!(self = [super initWithNibName:nil bundle:nil])) return nil;
	
	self.url = url;
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	__typeof(self) __self = self;

	[self.webView observeKeyPath:@keypath(self.webView, canGoBack) changeBlock:^(NSDictionary *change)
	{
		__self.backButton.enabled = __self.webView.canGoBack;
	}];

	[self.webView observeKeyPath:@keypath(self.webView, canGoForward) changeBlock:^(NSDictionary *change)
	{
		__self.forwardButton.enabled = __self.webView.canGoForward;
	}];
	
	[self.webView observeKeyPath:@keypath(self.webView, loading) changeBlock:^(NSDictionary *change)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = __self.webView.loading;
		 
		NSString *imageName = __self.webView.loading ? @"delete.png" : @"reload.png";
		__self.reloadButton.image = [UIImage imageNamed:imageName];
		 
		__self.navigationItem.title = __self.webView.loading ? [__self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] : @"";
	}];
	
	[self observeKeyPath:@keypath(self, webView) changeBlock:^(NSDictionary *change) {
		[__self.webView loadRequest:[NSURLRequest requestWithURL:__self.url]];
	}];


	[self observeKeyPath:@keypath(self, url) changeBlock:^(NSDictionary *change) {
		[__self.webView loadRequest:[NSURLRequest requestWithURL:__self.url]];
	}];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	[self.webView loadRequest:request];
	
	return YES;
}

- (IBAction)reloadButtonPushed:(id)sender
{
	if (self.webView.loading)
	{
		[self.webView stopLoading];
	} else {
		[self.webView reload];
	}
}

- (IBAction)backButtonPush:(id)sender
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
			cancelButtonTitle:PopupLabels[PopupCancel]
	   destructiveButtonTitle:nil
			otherButtonTitles:PopupLabels[PopupCopyLink], PopupLabels[PopupOpenInSafari], nil];
	
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
	switch (buttonIndex) {
		case PopupCopyLink:
			[[UIPasteboard generalPasteboard] setValue:self.webView.request.URL.absoluteString
									 forPasteboardType:(NSString *)kUTTypeUTF8PlainText];
			break;
		case PopupOpenInSafari:
			[[UIApplication sharedApplication] openURL:self.webView.request.URL];
			break;
		default:
			break;
	}
}

@end
