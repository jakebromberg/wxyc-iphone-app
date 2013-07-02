//
//  WXYCStreamController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 7/1/13.
//  Copyright (c) 2013 WXYC. All rights reserved.
//

#import "WXYCStreamController.h"

@implementation WXYCStreamController

static WXYCStreamController *wxyc;

+ (instancetype)wxyc
{
	if (!wxyc)
		wxyc = [[WXYCStreamController alloc] initWithURL:[NSURL URLWithString:@"http://152.2.204.90:8000/wxyc.mp3"]];
	
	return wxyc;
}

@end
