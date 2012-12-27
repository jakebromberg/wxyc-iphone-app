//
//  BlogEntryTableViewController.h
//  WXYCapp
//
//  Created by Jake on 2/28/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BlogEntryTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *description;
@property (nonatomic, strong) IBOutlet UILabel *date;

@end
