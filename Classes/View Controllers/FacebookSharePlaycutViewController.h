//
//  FacebookSharePlaycutViewController.h
//  WXYCapp
//
//  Created by Jake on 12/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "FbGraph.h"
#import "ShareItemTextInputViewController.h"

@interface FacebookSharePlaycutViewController : ShareItemTextInputViewController
{
//	FbGraph *fbGraph;
	
	//we'll use this to store a feed post (when you press 'post me/feed').
	//when you press delete me/feed this is the post that's deleted
	NSString *feedPostId;
}

//@property (nonatomic, retain) FbGraph *fbGraph;
@property (nonatomic, retain) NSString *feedPostId;

//- (void) testStreamPublish;

@end
