//
//  PlaylistEntryDetailsViewController.h
//  WXYCapp
//
//  Created by Jake on 11/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "PlaycutNavBarTitleView.h"
#import "GoogleImageSearch.h"
#import "Playcut.h"
#import "LazyImageLoaderView.h"

@interface PlaycutViewController : UIViewController <GoogleImageSearchDelegate, 
													 UIActionSheetDelegate, 
													 MFMailComposeViewControllerDelegate>
{
	UIImageView *reflectionView;
	UIActivityIndicatorView *retrievingImageIndicator;
	
	PlaycutNavBarTitleView *titleDeets;
	
	NSManagedObjectContext *managedObjectContext;
	Playcut *currentData;
}

- (id) initWithPlaycut:(Playcut*)playcut;
- (void) refreshViews;

@property (nonatomic, strong) Playcut *playcut;

@property (nonatomic, strong) IBOutlet LazyImageLoaderView *albumArt;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *retrievingImageIndicator;
@property (nonatomic, strong) IBOutlet UIImageView *reflectionView;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *favoriteButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *previousButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *nextButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *searchButton;

- (IBAction)favoriteButtonPush:(id)sender;
- (IBAction)previousButtonPush:(id)sender;
- (IBAction)nextButtonPush:(id)sender;
- (IBAction)searchButtonPush:(id)sender;
- (IBAction)actionButtonPush:(id)sender;

@end
