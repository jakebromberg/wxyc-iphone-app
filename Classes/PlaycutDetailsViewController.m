//
//  PlaycutDetailsViewController.m
//  WXYCapp
//
//  Created by Jake Bromberg on 3/11/12.
//  Copyright (c) 2012 WXYC. All rights reserved.
//

#import "PlaycutDetailsViewController.h"

@interface PlaycutDetailsViewController ()

@end

@implementation PlaycutDetailsViewController

@synthesize entity;
@synthesize artist;
@synthesize song;
@synthesize album;
@synthesize label;

- (id)init {
    self = [super initWithNibName:@"PlaycutDetails" bundle:nil];
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
