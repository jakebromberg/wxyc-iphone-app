//
//  PlaycutCell.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/6/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutCell.h"
#import "PlaycutCellButton.h"
#import "NSObject+KVOBlocks.h"
#import "NSArray+Additions.h"
#import "XYCAlbumArtDownloadOperation.h"
#import <MagicalRecord/MagicalRecordShorthand.h>

@interface PlaycutCell ()

#pragma mark IBOutlet Stuff

@property (nonatomic, weak, readwrite) IBOutlet UIImageView *albumArt;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

#pragma mark State

@property (nonatomic, strong) __block Playcut *entity;
@property (nonatomic, strong) XYCAlbumArtDownloadOperation *artDownloadOperation;

@end

#pragma mark -

@implementation PlaycutCell

@dynamic entity;

- (void)awakeFromNib
{
	[super awakeFromNib];
	
	__weak __typeof(self) __self = self;
	
	[self observeKeyPath:@keypath(self, entity.PrimaryImage) changeBlock:^(NSDictionary *change)
	{
		dispatch_async(dispatch_get_main_queue(), ^{
			__self.albumArt.image = [UIImage imageWithData:self.entity.PrimaryImage];
		});
	}];
}

- (void)setEntity:(Playcut *)playcut
{
	[super setEntity:playcut];
	
	self.artistLabel.text = playcut.Artist;
	self.titleLabel.text = playcut.Song;
	
	self.albumArt.image = self.imageForAlbumArt;
}

- (UIImage *)imageForAlbumArt
{
	if (self.entity.PrimaryImage)
	{
		return [UIImage imageWithData:self.entity.PrimaryImage];
	}
	
	id keywords = @[self.artistLabel.text, self.titleLabel.text];
	self.artDownloadOperation = [[XYCAlbumArtDownloadOperation alloc] initWithKeywords:keywords completed:self.downloadCompletion];
	
	return [UIImage imageNamed:@"album_cover_placeholder.PNG"];
}

- (XYCAlbumArtDownloaderCompletedBlock)downloadCompletion
{
	__block __typeof(self.entity.objectID) __objectID = self.entity.objectID;
	
	return ^(UIImage *image, NSData *data, NSError *error, BOOL finished)
	{
		if (error)
        {
			return;
        }
        
		Playcut *playcut = (Playcut *) [[NSManagedObjectContext contextForCurrentThread] objectWithID:__objectID];
		playcut.PrimaryImage = data;
		
		[playcut.managedObjectContext saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            if (error) {
                NSLog(@"the impossible happened");
            }
		}];
	};
}

- (void)setArtDownloadOperation:(XYCAlbumArtDownloadOperation *)artDownloadOperation
{
    [_artDownloadOperation cancel];
    
    _artDownloadOperation = artDownloadOperation;
}

#pragma Cell Lifecycle

- (void)prepareForReuse
{
	[self.artDownloadOperation cancel];
}

- (void)dealloc
{
    [_artDownloadOperation cancel];
	[self removeBlockObservers];
}

@end
