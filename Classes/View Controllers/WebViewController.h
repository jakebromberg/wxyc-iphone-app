//
//  Created by Jake Bromberg.
//  Copyright WXYC 2009-10. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate>

- (void)loadURL:(NSURL *)url;

- (IBAction)reloadButtonPush:(id)sender;
- (IBAction)backButtonPush:(id)sender;
- (IBAction)forwardButtonPush:(id)sender;
- (IBAction)actionButtonPush:(id)sender;

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end
