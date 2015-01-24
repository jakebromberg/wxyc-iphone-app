//
//  FavoriteShareButton.m
//  WXYCapp
//
//  Created by Jake Bromberg on 10/15/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "FavoriteShareButton.h"
#import "FavoriteShareAction.h"

@implementation FavoriteShareButton

- (Class<PlaycutCellShareAction>)playcutCellShareAction
{
	return [FavoriteShareAction class];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	self.highlighted = NO;
}

- (void)setPlaycut:(Playcut *)playcut
{
	[super setPlaycut:playcut];
	
	[self addObserver:self forKeyPath:@keypath(self, playcut.Favorite) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:NULL];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@keypath(self, playcut.Favorite)])
	{
		[self refreshFavoriteIcon];
	}
}

- (void)refreshFavoriteIcon
{
	UIImage *favoriteIcon = [self favoriteIconImageForState:[self.playcut.Favorite isEqual:@YES]];
	[self setImage:favoriteIcon forState:UIControlStateNormal];
}

- (UIImage *)favoriteIconImageForState:(BOOL)state
{
	NSString *imageName = state ? @"favorites-share-favorited.png" : @"favorites-share.png";
	
	return [UIImage imageNamed:imageName];
}

@end
