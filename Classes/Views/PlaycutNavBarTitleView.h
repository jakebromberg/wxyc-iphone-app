//
//  PlaycutDetailsNavigationBarTitleView.h
//  WXYCapp
//
//  Created by Jake on 11/2/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlaycutNavBarTitleView : UIView {
	UILabel *artistLabel;
	UILabel *trackLabel;
	UILabel *albumLabel;
}
@property (nonatomic, retain) IBOutlet UILabel *artistLabel;
@property (nonatomic, retain) IBOutlet UILabel *trackLabel;
@property (nonatomic, retain) IBOutlet UILabel *albumLabel;

@end
