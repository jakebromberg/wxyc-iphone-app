//
//  FavoritesTableViewController.m
//  WXYCapp
//
//  Created by Jake on 10/19/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "PlaycutCell.h"

@implementation FavoritesTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UINib *playcutCellNib = [UINib nibWithNibName:NSStringFromClass([PlaycutCell class]) bundle:nil];
    [self.tableView registerNib:playcutCellNib forCellReuseIdentifier:NSStringFromClass([PlaycutCell class])];
}

@end
