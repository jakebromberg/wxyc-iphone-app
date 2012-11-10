//
//  PlaylistEntryDetailsViewController.m
//  WXYCapp
//
//  Created by Jake on 11/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "PlaycutViewController.h"
#import "PlaycutNavBarTitleView.h"
#import "Playcut.h"
#import "UIImage+ProportionalFill.h"
#import "GoogleImageSearch.h"
#import "WXYCDataStack.h"
#import "WebViewController.h"
//#import "Reachability.h"
#import "TweetPlaycutViewController.h"
#import "PlaylistController.h"
#import "FacebookSharePlaycutViewController.h"

@interface PlaycutViewController (){
	GoogleImageSearch *gis;
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height;
@end

@implementation PlaycutViewController

enum AlertTableSections {
	kUIAction_Email = 0,
	kUIAction_Twitter,
	kUIAction_Facebook,
	kUIAlert_LastFM,
};

//@synthesize delegate;
@synthesize albumArt;
@synthesize retrievingImageIndicator;
@synthesize reflectionView;

@synthesize playcut = _playcut;

@synthesize favoriteButton;
@synthesize previousButton;
@synthesize nextButton;
@synthesize searchButton;

static const CGFloat kDefaultReflectionFraction = 0.15;
static const CGFloat kDefaultReflectionOpacity = 0.40;

- (id) initWithPlaycut:(Playcut*)playcut
{
	if (self = [super initWithNibName:@"DetailsView" bundle:nil])
	{
		self.playcut = playcut;
	}
	
	return self;
}

#pragma mark -
#pragma mark Segmented Control business

-(void)redrawButtonState {
//	[self.previousButton setEnabled:[delegate hasPrev]];
//	[self.nextButton setEnabled:[delegate hasNext]];
}

#pragma mark -
#pragma mark - Image Reflection
//TODO: put this somewhere else
CGImageRef CreateGradientImage(int pixelsWide, int pixelsHigh)
{
	CGImageRef theCGImage = NULL;
	
	// gradient is always black-white and the mask must be in the gray colorspace
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	// create the bitmap context
	CGContextRef gradientBitmapContext = CGBitmapContextCreate(NULL, pixelsWide, pixelsHigh,
															   8, 0, colorSpace, kCGImageAlphaNone);
	
	// define the start and end grayscale values (with the alpha, even though
	// our bitmap context doesn't support alpha the gradient requires it)
	CGFloat colors[] = {0.0, 1.0, 1.0, 1.0};
	
	// create the CGGradient and then release the gray color space
	CGGradientRef grayScaleGradient = CGGradientCreateWithColorComponents(colorSpace, colors, NULL, 2);
	CGColorSpaceRelease(colorSpace);
	
	// create the start and end points for the gradient vector (straight down)
	CGPoint gradientStartPoint = CGPointZero;
	CGPoint gradientEndPoint = CGPointMake(0, pixelsHigh);
	
	// draw the gradient into the gray bitmap context
	CGContextDrawLinearGradient(gradientBitmapContext, grayScaleGradient, gradientStartPoint,
								gradientEndPoint, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(grayScaleGradient);
	
	// convert the context into a CGImageRef and release the context
	theCGImage = CGBitmapContextCreateImage(gradientBitmapContext);
	CGContextRelease(gradientBitmapContext);
	
	// return the imageref containing the gradient
    return theCGImage;
}

CGContextRef MyCreateBitmapContext(int pixelsWide, int pixelsHigh)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	
	// create the bitmap context
	CGContextRef bitmapContext = CGBitmapContextCreate (NULL, pixelsWide, pixelsHigh, 8,
														0, colorSpace,
														// this will give us an optimal BGRA format for the device:
														(kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
	CGColorSpaceRelease(colorSpace);
	
    return bitmapContext;
}

- (UIImage *)reflectedImage:(UIImageView *)fromImage withHeight:(NSUInteger)height
{
    if(height == 0)
		return nil;
    
	// create a bitmap graphics context the size of the image
	CGContextRef mainViewContentContext = MyCreateBitmapContext(fromImage.bounds.size.width, height);
	
	// create a 2 bit CGImage containing a gradient that will be used for masking the 
	// main view content to create the 'fade' of the reflection.  The CGImageCreateWithMask
	// function will stretch the bitmap image as required, so we can create a 1 pixel wide gradient
	CGImageRef gradientMaskImage = CreateGradientImage(1, height);
	
	// create an image by masking the bitmap of the mainView content with the gradient view
	// then release the  pre-masked content bitmap and the gradient bitmap
	CGContextClipToMask(mainViewContentContext, CGRectMake(0.0, 0.0, fromImage.bounds.size.width, height), gradientMaskImage);
	CGImageRelease(gradientMaskImage);
	
	// In order to grab the part of the image that we want to render, we move the context origin to the
	// height of the image that we want to capture, then we flip the context so that the image draws upside down.
	CGContextTranslateCTM(mainViewContentContext, 0.0, height);
	CGContextScaleCTM(mainViewContentContext, 1.0, -1.0);
	
	// draw the image into the bitmap context
	CGContextDrawImage(mainViewContentContext, fromImage.bounds, fromImage.image.CGImage);
	
	// create CGImageRef of the main view bitmap content, and then release that bitmap context
	CGImageRef reflectionImage = CGBitmapContextCreateImage(mainViewContentContext);
	CGContextRelease(mainViewContentContext);
	
	// convert the finished reflection image to a UIImage 
	UIImage *theImage = [UIImage imageWithCGImage:reflectionImage];
	
	// image is retained by the property setting above, so we can release the original
	CGImageRelease(reflectionImage);
	
	return theImage;
}

#pragma mark -
#pragma mark GoogleImageSearch delegate business

- (void)backgroundAlbumCoverSearch:(Playcut*)playcut {
	@autoreleasepool {
		NSArray *searchTerms = @[[self.playcut valueForKey:@"artist"], [self.playcut valueForKey:@"album"]];
		NSString *searchTermsString = [searchTerms componentsJoinedByString:@"+"];
		searchTermsString = [searchTermsString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
		
		NSArray *results = [gis synchronizedSearchWithString:searchTermsString];
		
		NSArray *innerResults = (NSArray*) ((NSDictionary*) results)[@"responseData"][@"results"];
		if ([innerResults count] > 0) {
			NSDictionary *firstResult = innerResults[0];
			
			NSURL *urlOfImage = [NSURL URLWithString:firstResult[@"url"]];
			
			albumArt.imageURL = urlOfImage;
			[self.playcut setPrimaryImage:UIImagePNGRepresentation(albumArt.image)];
		}
	}
}

#pragma mark -

- (void)refreshViews {
	[retrievingImageIndicator stopAnimating];
	
	titleDeets.artistLabel.text = [currentData valueForKey:@"artist"];
	titleDeets.albumLabel.text = [currentData valueForKey:@"album"];
	titleDeets.trackLabel.text = [currentData valueForKey:@"song"];
	
	NSUInteger reflectionHeight = albumArt.bounds.size.height * kDefaultReflectionFraction;
	
	if ([currentData valueForKey:@"primaryImage"]) {
		UIImage *image = [UIImage imageWithData:[currentData valueForKey:@"primaryImage"]]; 
		image = [image imageCroppedToFitSize:albumArt.frame.size];
		albumArt.image = image;
		reflectionView.image = [self reflectedImage:albumArt withHeight:reflectionHeight];
		reflectionView.alpha = kDefaultReflectionOpacity;
	} else {
		UIImage *defaultImage = [UIImage imageNamed:@"album_cover_placeholder.PNG"];
		defaultImage = [defaultImage imageCroppedToFitSize:albumArt.frame.size];
		albumArt.image = defaultImage;
		reflectionView.image = [self reflectedImage:albumArt withHeight:reflectionHeight];
		reflectionView.alpha = kDefaultReflectionOpacity;
		
		[retrievingImageIndicator startAnimating];
		[self performSelectorInBackground:@selector(backgroundAlbumCoverSearch:) withObject:currentData];
	}
	
	[favoriteButton setImage:[UIImage imageNamed:
							  ([[currentData valueForKey:@"favorite"] boolValue] 
								 ? @"favorites-toolbar-icon-filled.png"
								 : @"favorites-toolbar-icon-unfilled.png")
								 ]];

	[self redrawButtonState];
}

-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:first@example.com?cc=second@example.com,third@example.com&subject=Hello from California!";
	NSString *body = @"&body=It is raining in sunny California!";
	
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == kUIAction_Email) {
		Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
		if (mailClass != nil) {
			// We must always check whether the current device is configured for sending emails
			if ([mailClass canSendMail])
			{
				MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
				picker.mailComposeDelegate = self;
				
				[picker setSubject:@"Playing on WXYC"];
				
				// Fill out the email body text
				NSString *emailBody = [NSString stringWithFormat:@"\"%@\" by %@ from album %@",
									   titleDeets.trackLabel.text,
									   titleDeets.artistLabel.text,
									   titleDeets.albumLabel.text];
				[picker setMessageBody:emailBody isHTML:NO];
				
				[self presentModalViewController:picker animated:YES];
			} else {
				[self launchMailAppOnDevice];
			}
		} else {
			[self launchMailAppOnDevice];
		}
		
	}
	
	if (buttonIndex == kUIAction_Twitter) {
		TweetPlaycutViewController *controller = [[TweetPlaycutViewController alloc] initWithNibName:@"ShareItemTextInputView" bundle:nil];
		//TODO: this is a bunch of bullshit. I should be able to pass the controller
		//a Playcut* object but something in my object keeps defaulting to nil
		controller.artistString = titleDeets.artistLabel.text;
		controller.titleString = titleDeets.trackLabel.text;
		controller.albumString = titleDeets.albumLabel.text;
		UINavigationController *navigationController = [[UINavigationController alloc]
														initWithRootViewController:controller];
		[navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[controller setDelegate:self];
		[[self navigationController] presentModalViewController:navigationController animated:YES];
	}
	
	if (buttonIndex == kUIAction_Facebook) {
		FacebookSharePlaycutViewController *controller = [[FacebookSharePlaycutViewController alloc] initWithNibName:@"ShareItemTextInputView" bundle:nil];
		controller.artistString = titleDeets.artistLabel.text;
		controller.titleString = titleDeets.trackLabel.text;
		controller.albumString = titleDeets.albumLabel.text;
		UINavigationController *navigationController = [[UINavigationController alloc]
														initWithRootViewController:controller];
		[navigationController.navigationBar setBarStyle:UIBarStyleBlackOpaque];
		[controller setDelegate:self];
		[[self navigationController] presentModalViewController:navigationController animated:YES];
		
	}
}

- (IBAction)previousButtonPush:(id)sender {
//	currentData = [delegate NPprev];
	[self refreshViews];
}

- (IBAction)nextButtonPush:(id)sender {
//	NSLog(@"nextButtonPush delegate %@", delegate);
//	[delegate NPnext];
//	currentData = [delegate NPnext];
	[self refreshViews];
}

- (IBAction)searchButtonPush:(id)sender {
//	currentData = [delegate NPcurrent];
	NSString *query = [NSString stringWithFormat: @"%@", currentData.artist];
	query = [query stringByAppendingString:@" &"];
	query = [query stringByAppendingString:[NSString stringWithFormat: @"%@", [currentData song]]];
	query = [query stringByReplacingOccurrencesOfString:@"&" withString:@""];
	query = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	query = [@"http://www.google.com/search?q=" stringByAppendingString:query];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:query]];
	
	NSLog(@"query %@", query);
	
	WebViewController *webViewController = [[WebViewController alloc] initWithNibName:@"WebView" bundle:nil];
	webViewController.hidesBottomBarWhenPushed = YES;
	[[self navigationController] pushViewController:webViewController animated:YES];
	[webViewController.webView loadRequest:request];
}

- (IBAction)actionButtonPush:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do what now?"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
													otherButtonTitles:@"Email", @"Twitter", @"Facebook", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	actionSheet.destructiveButtonIndex = 3;	// make the second button red (destructive)
	[actionSheet showInView:self.view]; // show from our table view (pops up in the middle of the table)
}

- (IBAction)favoriteButtonPush:(id)sender {
//	currentData = [delegate NPcurrent];
	
	NSLog(@"currentData.Favorite %@", currentData.favorite);

	[currentData setFavorite:[[NSNumber alloc] initWithBool:![currentData.favorite boolValue]]];
	
	[self refreshViews];
}

#pragma mark -
#pragma mark UIViewController overrides

- (void)viewDidLoad {
//	currentData = [delegate NPcurrent];
	gis = [[GoogleImageSearch alloc] initWithDelegate:self];
	
	NSArray* topLevelObjects = //(PlaycutDetailsNavigationBarTitleView*)
		[[NSBundle mainBundle] loadNibNamed:@"PlaycutNavBarTitleView" owner:nil options:nil];
	titleDeets = (PlaycutNavBarTitleView *)topLevelObjects[0];
	self.navigationItem.titleView = titleDeets;
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(redrawButtonState)
                                                 name:LPStatusChangedNotification
                                               object:nil];	
	
	[self refreshViews];
}

- (void)viewWillDisappear:(BOOL)animated {
	NSError *error = nil;
//	currentData = [delegate NPcurrent];
	if (![currentData.managedObjectContext save:&error]) {
		NSLog(@"%@",error);
	}
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter] removeObserver:self
											  forKeyPath:LPStatusChangedNotification];
}


@end