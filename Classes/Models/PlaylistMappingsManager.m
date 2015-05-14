//
//  PlaylistMapping.m
//  WXYCapp
//
//  Created by Jake Bromberg on 4/15/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

//#import <RestKit/RestKit.h>
#import "PlaylistMappingsManager.h"
#import "PlaycutMapping.h"
#import "BreakpointMapping.h"
#import "TalksetMapping.h"

@implementation PlaylistMappingsManager

+ (void)addResponseDescriptorsToObjectManager:(RKObjectManager *)objectManager
{
	NSArray *mappings = @[
		[PlaycutMapping class],
		[TalksetMapping class],
		[BreakpointMapping class]
	];
	
	for (Class<XYCPlaylistMapping> mapping in mappings)
	{
		RKResponseDescriptor *descriptor = [self responseDescriptorForMapping:mapping];
		[objectManager addResponseDescriptor:descriptor];
	}
}

+ (RKResponseDescriptor *)responseDescriptorForMapping:(Class<XYCPlaylistMapping>)mapping
{
	RKEntityMapping *m = [RKEntityMapping
						  mappingForEntityForName:[mapping entityName]
						  inManagedObjectStore:[RKManagedObjectStore defaultStore]];
	m.identificationAttributes = [mapping identificationAttributes];
	
	[m addAttributeMappingsFromDictionary:[mapping attributeMappings]];
	
	return [RKResponseDescriptor
			responseDescriptorWithMapping:m
			method:RKRequestMethodGET
			pathPattern:nil
			keyPath:[mapping keyPath]
			statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end
