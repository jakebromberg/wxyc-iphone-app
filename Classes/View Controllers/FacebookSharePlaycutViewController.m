//
//  FacebookSharePlaycutViewController.m
//  WXYCapp
//
//  Created by Jake on 12/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "FacebookSharePlaycutViewController.h"
#import "SBJSON.h"

static NSString* kAppId = @"127717163956895";
//static NSString* kAPIKey = @"dea7d883b430466e46b2ac377701da2e";
//static NSString* kAppSecret = @"c87efac9a5fd067338292389b3208927";

@implementation FacebookSharePlaycutViewController

//@synthesize fbGraph;
@synthesize feedPostId;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
//		_permissions =  [[NSArray arrayWithObjects: 
//						  @"publish_stream",@"read_stream", @"offline_access",nil] retain];
//	}
//	
//	return self;
//}

#pragma mark UIViewController

- (void) viewDidLoad {
	/*** UI stuff ***/
	UIBarButtonItem *postButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Post" 
									 style:UIBarButtonItemStyleDone 
									target:self 
									action:@selector(update:)];
	self.navigationItem.rightBarButtonItem = postButton;
	postButton.enabled = NO;
	
	UIBarButtonItem *cancelButton = 
	[[UIBarButtonItem alloc] initWithTitle:@"Cancel" 
									 style:UIBarButtonItemStyleBordered 
									target:self 
									action:@selector(cancel)];
	self.navigationItem.leftBarButtonItem = cancelButton;
	
	[self.wxycButton setTitle:@"YO" forState:UIControlStateNormal];
//	self.wxycButton.titleLabel.text = @"WXYC";
//	NSLog("%@", self.wxycButton.titleLabel.text);

	self.charCountLabel.text = @" ";// setHidden:YES]:
}

//- (void) viewWillAppear:(BOOL)animated {
//	[self resignFirstResponder];
//}

- (void) viewDidAppear:(BOOL)animated {
}

#pragma mark -
#pragma mark IBActions

- (void)cancel {
	[self.delegate dismissModalViewControllerAnimated:YES];
}

- (void)update:(id)sender {
	[self.myTextView resignFirstResponder];
//	self.fbGraph = [[FbGraph alloc] initWithFbClientID:kAppId];
	
	HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	HUD.delegate = self;
	HUD.labelText = @"Posting";
	[self.navigationController.view addSubview:HUD];
	[HUD show:YES];	
	
//	[fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:) andExtendedPermissions:@"user_photos,user_videos,publish_stream,offline_access" andSuperView:self.view];
}

#pragma mark -
#pragma mark FbGraph Callback Function
/**
 * This function is called by FbGraph after it's finished the authentication process
 **/
//- (void)fbGraphCallback:(id)sender {
//	NSMutableDictionary *variables = [NSMutableDictionary dictionaryWithCapacity:4];
//
//	[variables setObject:@"actions" forKey:@"{\"name\": \"Listen Now\", \"link\": \"http://wxyc.org/files/streams/wxyc-mp3.m3u\"}"];
//	[variables setObject:@"http://wxyc.org/files/img/caseyburns.gif" forKey:@"picture"];
//	[variables setObject:self.myTextView.text forKey:@"message"];
// 	[variables setObject:@"http://wxyc.org" forKey:@"link"];
// 	[variables setObject:@"WXYC Chapel Hill 89.3" forKey:@"name"];
// 	[variables setObject:[NSString stringWithFormat:@"%@ - %@", artistString, titleString] forKey:@"description"];
//	
//	FbGraphResponse *fb_graph_response = [fbGraph doGraphPost:@"me/feed" withPostVars:variables];
//	NSLog(@"postMeFeedButtonPressed:  %@", fb_graph_response.htmlResponse);
//	
//	//parse our json
//	SBJSON *parser = [[SBJSON alloc] init];
//	NSDictionary *facebook_response = [parser objectWithString:fb_graph_response.htmlResponse error:nil];	
//	[parser release];
//	
//	//let's save the 'id' Facebook gives us so we can delete it if the user presses the 'delete /me/feed button'
//	self.feedPostId = (NSString *)[facebook_response objectForKey:@"id"];
//	NSLog(@"feedPostId, %@", feedPostId);
//	NSLog(@"Now log into Facebook and look at your profile...");	
//	
//	[HUD hide:YES];
//	[self.delegate dismissModalViewControllerAnimated:YES];
//}

#pragma mark -
#pragma mark Facebook delegate stuff

//- (void) fbDidLogin {
//	_token = [_facebook.accessToken retain];
//	
//	[self testStreamPublish];
//}
//
//- (void) testStreamPublish {
//	SBJSON *jsonWriter = [[SBJSON new] autorelease];
//	
//	NSDictionary* actionLinks = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys: 
//														   @"Listen Now",@"text",@"http://wxyc.org/files/streams/wxyc-mp3.m3u",@"href", nil], nil];
//	
//	NSString *actionLinksStr = [jsonWriter stringWithObject:actionLinks];
//	NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
//								[NSString stringWithFormat:@"%@ - %@", artistString, titleString], @"name",
//								@"WXYC Chapel Hill 89.3FM", @"caption",
//								self.textView.text, @"description",
//								@"http://wxyc.org/", @"href", nil];
//	NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
//	NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//								   kAppId, kAPIKey,
//								   @"Share on Facebook",  @"user_message_prompt",
//								   actionLinksStr, @"action_links",
//								   attachmentStr, @"attachment",
//								   nil];
//	
//	
//	[_facebook dialog: @"stream.publish"
//			andParams: params
//		  andDelegate:self];
//	
//	[self.delegate dismissModalViewControllerAnimated:YES];
//}

#pragma mark -

- (void)textViewDidChange:(UITextView *)aTextView {
	self.navigationItem.rightBarButtonItem.enabled = [aTextView hasText];
}

- (void) insertString: (NSString *) insertingString intoTextView: (UITextView *) aTextView  
{  
    NSRange range = aTextView.selectedRange;  
    NSString * firstHalfString = [aTextView.text substringToIndex:range.location];  
    NSString * secondHalfString = [aTextView.text substringFromIndex: range.location];  
    aTextView.scrollEnabled = NO;  // turn off scrolling or you'll get dizzy ... I promise  
	
    aTextView.text = [NSString stringWithFormat: @"%@%@%@",  
					 firstHalfString,  
					 insertingString,  
					 secondHalfString];  
    range.location += [insertingString length];  
    aTextView.selectedRange = range;  
    aTextView.scrollEnabled = YES;  // turn scrolling back on.  
	
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
	[self insertString:@"WXYC"
		  intoTextView:self.myTextView];
}

@end