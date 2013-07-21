//
//  FavoriteShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/21/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FavoriteShareButton.h"
#import "FavoriteShareAction.h"

@implementation FavoriteShareButton

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if (![change[@"new"] isEqual:change[@"old"]])
		[self refreshImage];
}

- (void)refreshImage
{
	NSString *imageName = [[self.playcut valueForKey:@"favorite"] boolValue] ? @"favorites-share-favorited.png" : @"favorites-share.png";
	[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setPlaycut:(Playcut *)playcut
{
	[super setPlaycut:playcut];
	
	NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
	[self.playcut addObserver:self forKeyPath:@"Favorite" options:options context:NULL];
}

- (void)dealloc
{
	[self.playcut removeObserver:self forKeyPath:@"favorite"];
}

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [FavoriteShareAction class];
}

@end
