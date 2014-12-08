//
//  NSObject+LivePlaylistTableViewCellMappings.m
//  WXYCapp
//
//  Created by Jake Bromberg on 12/10/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "NSObject+LivePlaylistTableViewCellMappings.h"

#import "Playcut.h"
#import "PlaycutCell.h"
#import "Breakpoint.h"
#import "BreakpointCell.h"
#import "Talkset.h"
#import "TalksetCell.h"
#import "PlayerCell.h"

@implementation NSObject (LivePlaylistTableViewCellMappings)

- (Class)correspondingTableViewCellClass
{
	return Nil;
}

@end

@implementation Playcut (LivePlaylistTableViewCellMappings)

- (Class)correspondingTableViewCellClass
{
	return [PlaycutCell class];
}

@end

@implementation Breakpoint (LivePlaylistTableViewCellMappings)

- (Class)correspondingTableViewCellClass
{
	return [BreakpointCell class];
}

@end

@implementation Talkset (LivePlaylistTableViewCellMappings)

- (Class)correspondingTableViewCellClass
{
	return [TalksetCell class];
}

@end