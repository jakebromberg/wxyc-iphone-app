// 
//  Playcut.m
//  WXYCapp
//
//  Created by Jake on 11/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Playcut.h"


@implementation Playcut 

@dynamic request;
@dynamic artist;
@dynamic album;
@dynamic label;
@dynamic primaryImage;
@dynamic song;
@dynamic rotation;
@dynamic favorite;
@dynamic image;

@end

@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end