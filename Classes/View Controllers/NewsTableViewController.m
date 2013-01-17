//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import "NewsTableViewController.h"
#import "BlogEntryTableViewCell.h"
#import "NewsDetailViewController.h"
#import "SBJson.h"

@implementation NewsTableViewController

- (NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:html];
	
    while ([theScanner isAtEnd] == NO) {
		
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
		
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
		
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
				[ NSString stringWithFormat:@"%@>", text]
											   withString:@""];
    } // while //
	
	return html;
	
}

- (void)getJSONFeedWithNumEntries:(int)num referenceID:(int)referenceID direction:(NSString*)direction
{
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://wxyc.org/simplepie/iphoneappnewsfeed.php"]];
	[NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData.length = 0;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	// Store incoming data into a string and clear data
	NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	responseData.length = 0;
	
	_blogEntries = [[jsonString JSONValue] mutableCopy];
	
	// Update the table with data
	[self.tableView reloadData];
	
	[super dataSourceDidFinishLoadingNewData];
}

- (void)reloadTableViewDataSource {
	[_blogEntries removeAllObjects];
	[self getJSONFeedWithNumEntries:20 referenceID:1 direction:@"prev"];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.blogEntries.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	//NSLog(@"blog entries %@", blogEntries);
	NSUInteger row = [indexPath row];
	if ([_blogEntries count] == 0) { //i forget why we go through all this instead of just returning nil
		BlogEntryTableViewCell *blogCell = (BlogEntryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"BlogEntryCell"];
		
		if (blogCell==nil) {
			NSArray* topLevelObjects = //(BlogEntryTableViewCell*)
			[[NSBundle mainBundle]
			 loadNibNamed:@"BlogEntryTableViewCell" 
			 owner:nil options:nil];
			blogCell = (BlogEntryTableViewCell *)topLevelObjects[0];
		}
		
		return blogCell;
	}
	
	NSDictionary *blogEntry = _blogEntries[row];
	//NSLog(@"blogEntry %@", blogEntry);
	BlogEntryTableViewCell *blogCell = (BlogEntryTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"BlogEntryCell"];
	
	if (blogCell==nil) {
		NSArray* topLevelObjects =
			[[NSBundle mainBundle]
			 loadNibNamed:@"BlogEntryTableViewCell" 
			 owner:nil options:nil];
		blogCell = (BlogEntryTableViewCell *)topLevelObjects[0];
	}
		
	blogCell.title.text = blogEntry[@"title"];
	blogCell.description.text = [self flattenHTML:blogEntry[@"content"]];
	blogCell.date.text = blogEntry[@"date"];
	
	return blogCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.reloading) //we'll crash if we don't return while the table's reloading
	{
		UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
		[cell setSelected:NO animated:YES];
		return;
	}
	
    // Navigation logic may go here. Create and push another view controller.
	NSUInteger row = [indexPath row];

	NewsDetailViewController *webViewController = [[NewsDetailViewController alloc] initWithNibName:@"SimpleWebView" bundle:nil];
	webViewController.items = _blogEntries;
	webViewController.currentRow = row;
	webViewController.delegate = self.tableView;
	
	[[self navigationController] pushViewController:webViewController animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	responseData = [NSMutableData data];
	_blogEntries = [[NSMutableArray alloc] init];
	
	refreshHeaderView.lastUpdatedDate = [NSDate date];
	[self showReloadAnimationAnimated:YES];
	[self reloadTableViewDataSource];	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.tableView.rowHeight = 80.0f;
}



@end
