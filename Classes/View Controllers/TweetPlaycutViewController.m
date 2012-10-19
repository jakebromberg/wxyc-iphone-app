//
//  ShareItemTextInputViewController.m
//  WXYCapp
//
//  Created by Jake on 11/16/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "TweetPlaycutViewController.h"
//#import "SA_OAuthTwitterEngine.h"
//#import "SA_OAuthTwitterController.h"

@implementation TweetPlaycutViewController


enum ShareViewBarButtonItems {
	kCancelButton = 0,
	kTweetButton
};

#pragma mark -
#pragma mark MGTwitterEngineDelegate methods


- (void)requestSucceeded:(NSString *)connectionIdentifier
{
    NSLog(@"Request succeeded for connectionIdentifier = %@", connectionIdentifier);
	[HUD hide:YES];
	[self.delegate dismissModalViewControllerAnimated:YES];
}


- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
	[HUD hide:YES];
	
	UIAlertView *alert =
	[[UIAlertView alloc] initWithTitle: @"Tweet Failed"
							   message: @"The server failed to respond."
							  delegate: self
					 cancelButtonTitle: @"OK"
					 otherButtonTitles: nil];
    [alert show];
	
	[self.myTextView becomeFirstResponder];
	
    NSLog(@"Request failed for connectionIdentifier = %@, error = %@ (%@)", 
          connectionIdentifier, 
          [error localizedDescription], 
          [error userInfo]);
}


- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got statuses for %@:\r%@", connectionIdentifier, statuses);
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got direct messages for %@:\r%@", connectionIdentifier, messages);
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user info for %@:\r%@", connectionIdentifier, userInfo);
}


- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got misc info for %@:\r%@", connectionIdentifier, miscInfo);
}


- (void)searchResultsReceived:(NSArray *)searchResults forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got search results for %@:\r%@", connectionIdentifier, searchResults);
}


- (void)socialGraphInfoReceived:(NSArray *)socialGraphInfo forRequest:(NSString *)connectionIdentifier
{
	NSLog(@"Got social graph results for %@:\r%@", connectionIdentifier, socialGraphInfo);
}

- (void)userListsReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got user lists for %@:\r%@", connectionIdentifier, userInfo);
}
//
//- (void)accessTokenReceived:(OAToken *)aToken forRequest:(NSString *)connectionIdentifier
//{
//	NSLog(@"Access token received! %@",aToken);
//	
//	token = [aToken retain];
////	[self runTests];
//}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier
{
    NSLog(@"Got an object for %@: %@", connectionIdentifier, dictionary);
}

#pragma mark -

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData:(NSString *) data forUsername:(NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
//#pragma mark SA_OAuthTwitterControllerDelegate
//- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
//	NSLog(@"Authenicated for %@", username);
//}
//
//- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
//	NSLog(@"Authentication Failed!");
//}
//
//- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
//	NSLog(@"Authentication Canceled.");
//}
//
////=============================================================================================================================
//#pragma mark TwitterEngineDelegate
//
//- (void)tweet:(id)sender {
//	twitterEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
//	twitterEngine.consumerKey = myConsumerKey;
//	twitterEngine.consumerSecret = myConsumerSecret;
//	
//	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:twitterEngine 
//																								   delegate: self];
//	
//	if (controller) 
//		[self presentModalViewController: controller animated: YES];
//	else {
//		HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
//		[self.navigationController.view addSubview:HUD];
//		HUD.delegate = self;
//		HUD.labelText = @"Tweeting";
//		[HUD show:YES];
//		
//		[self.myTextView resignFirstResponder];
//		
//		[twitterEngine sendUpdate:self.myTextView.text];
//	}	
//}

-(void) statuses_update_callback:(NSData *)data {
	NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
}

#pragma mark -

- (void)cancel {
	[self.delegate dismissModalViewControllerAnimated:YES];
}

- (void)textViewDidChange:(UITextView *)aTextView {
	NSInteger charCount = 140 - [[aTextView text] length];
	self.charCountLabel.text = [NSString stringWithFormat:@"%i",charCount];
	
	self.navigationItem.rightBarButtonItem.enabled = [aTextView hasText];
	
	if (charCount < 0) {
		self.charCountLabel.textColor = [UIColor colorWithRed:205.0/255.0 green:0 blue:0 alpha:1.0];
	} else {
		self.charCountLabel.textColor = [UIColor colorWithWhite:0.0 alpha:.66];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	NSLog(@"albumButton %@",albumButton);
	
	myConsumerKey = @"EH1KBn2sM4EFv2KEUUAQ";
	myConsumerSecret = @"3mcWBnKTl8sQlNgPSIgO42KzPYeiD1sG14pZ1WixU";
	
//	[self.textView becomeFirstResponder];

	/*** UI stuff ***/
	UIBarButtonItem *tweetButton = 
		[[UIBarButtonItem alloc] initWithTitle:@"Tweet" 
										 style:UIBarButtonItemStyleDone 
										target:self 
										action:@selector(tweet:)];
	self.navigationItem.rightBarButtonItem = tweetButton;
	tweetButton.enabled = NO;
	
	UIBarButtonItem *cancelButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
									 style:UIBarButtonItemStyleBordered 
									target:self 
									action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void) insertString: (NSString *) insertingString intoTextView: (UITextView *) textView  
{  
    NSRange range = textView.selectedRange;  
    NSString * firstHalfString = [textView.text substringToIndex:range.location];  
    NSString * secondHalfString = [textView.text substringFromIndex: range.location];  
    textView.scrollEnabled = NO;  // turn off scrolling or you'll get dizzy ... I promise  
	
    textView.text = [NSString stringWithFormat: @"%@%@%@",  
					 firstHalfString,  
					 insertingString,  
					 secondHalfString];  
    range.location += [insertingString length];  
    textView.selectedRange = range;  
    textView.scrollEnabled = YES;  // turn scrolling back on.  
	
}

- (IBAction)pushedArtist:(id)sender {
	[self insertString:self.artistString
		  intoTextView:self.myTextView];
}

- (IBAction)pushedTitle:(id)sender {
	[self insertString:self.titleString
		  intoTextView:self.myTextView];
}

- (IBAction)pushedAlbum:(id)sender {
	[self insertString:self.albumString
		  intoTextView:self.myTextView];
}

- (IBAction)pushedWXYC:(id)sender {
	[self insertString:@"#wxyc"
		  intoTextView:self.myTextView];
}

@end
