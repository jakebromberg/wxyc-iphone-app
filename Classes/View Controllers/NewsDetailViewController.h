//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebViewController.h"
//#import "NewsTableViewController.h"

@interface NewsDetailViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, assign) int currentRow;
@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UITableView *delegate;

@end
