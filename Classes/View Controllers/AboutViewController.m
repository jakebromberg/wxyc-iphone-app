//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "AboutViewController.h"
#import	"WebViewController.h"

@implementation AboutViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	NSString* aboutTemplatePath = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
	NSURL* url = [NSURL fileURLWithPath:aboutTemplatePath];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	[(UIWebView *)self.view loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		WebViewController *webViewController = [[WebViewController alloc] init];
		
		[self.view.window.rootViewController presentViewController:webViewController animated:YES completion:nil];
		[webViewController loadURL:request.URL];
		webViewController.webView.scalesPageToFit = YES;
		
		return NO;
	}
	
	return YES;
}

@end