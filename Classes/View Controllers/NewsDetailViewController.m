//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "NewsDetailViewController.h"

#define UP 0
#define DOWN 1

@implementation NewsDetailViewController

@synthesize items;
@synthesize currentRow;
@synthesize segControl;
@synthesize webView;
@synthesize delegate;

-(void)redrawButtonState {
	[self.segControl setEnabled:self.currentRow>0 forSegmentAtIndex:0];
	[self.segControl setEnabled:self.currentRow<[self.items count]-1 forSegmentAtIndex:1];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSLog(@"expected:%d, got:%d", UIWebViewNavigationTypeLinkClicked, navigationType);
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
		webViewController.hidesBottomBarWhenPushed = YES;
		[[self navigationController] pushViewController:webViewController animated:YES];
		[webViewController.webView setScalesPageToFit:YES];
		[webViewController.webView loadRequest:request];
	}
	
	return YES;
}

-(void) showItem:(int)index {
	NSDictionary *blogEntry = items[index];
	
	NSString *title = blogEntry[@"title"];
	NSString *date = blogEntry[@"date"];
	NSString *author =  blogEntry[@"author"];
	NSString *content = blogEntry[@"content"];
	
	NSString *page = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"article" ofType:@"html"]];
	page = [page stringByReplacingOccurrencesOfString:@"##title##" withString:title];
	page = [page stringByReplacingOccurrencesOfString:@"##date##" withString:date];
	page = [page stringByReplacingOccurrencesOfString:@"##author##" withString:
			([author isEqualToString:@"none"] ? @"WXYC" : author)];
	page = [page stringByReplacingOccurrencesOfString:@"##content##" withString:content];

	[webView loadHTMLString:page baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

	//sets highlighted cell in parent table view to one corresponding to the current item shown
	if (![[delegate indexPathsForVisibleRows] containsObject:[NSIndexPath indexPathForRow:index inSection:0]])
		[delegate selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] 
							  animated:NO 
						scrollPosition:UITableViewScrollPositionMiddle ];
	
}

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was selected, handle it here 
	
	UISegmentedControl *segmentedControl = (UISegmentedControl *)sender;
	switch (segmentedControl.selectedSegmentIndex) {
		case UP:
			if (self.currentRow>0) {
				self.currentRow = self.currentRow-1;
				[self showItem:currentRow];
			}
			break;
			
		case DOWN: // Down clicked
			if (self.currentRow < [items count]-1) {
				self.currentRow = self.currentRow+1;
				[self showItem:currentRow];
			}
			break;
			
		default:
			break;
	}
	[self redrawButtonState];
}

-(void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self showItem:currentRow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// "Segmented" control to the right
	UISegmentedControl *segmentedControl = 
	[[UISegmentedControl alloc] initWithItems:
	 @[[UIImage imageNamed:@"up.png"],
	  [UIImage imageNamed:@"down.png"]]];
	[segmentedControl setContentOffset:CGSizeMake(0, 1.0) forSegmentAtIndex:0];
	
	[segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	segmentedControl.frame = CGRectMake(0, 0, 90, 30.0);
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	segmentedControl.momentary = YES;
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    
	self.navigationItem.rightBarButtonItem = segmentBarItem;
	self.segControl = segmentedControl;
	[self redrawButtonState];
}

@end
