//
//  ShareItemTextInputViewController.m
//  WXYCapp
//
//  Created by Jake on 12/1/10.
//  Copyright 2010 WXYC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ShareItemTextInputViewController.h"
#import "MBProgressHUD.h"

@implementation ShareItemTextInputViewController

@synthesize myTextView;
@synthesize accessoryView;

@synthesize artistButton;
@synthesize titleButton;
@synthesize albumButton;
@synthesize wxycButton;
@synthesize charCountLabel;

@synthesize artistString;
@synthesize titleString;
@synthesize albumString;

@synthesize delegate;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Observe keyboard hide and show notifications to resize the text view appropriately.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.myTextView = nil;
    self.accessoryView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    // Make the keyboard appear when the application launches.
    [super viewWillAppear:animated];
    [myTextView becomeFirstResponder];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Text view delegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    /*
     You can create the accessory view programmatically (in code), 
	 in the same nib file as the view controller's main view, or 
	 from a separate nib file. This example illustrates the 
	 latter; it means the accessory view is loaded lazily -- only 
	 if it is required.
     */
    
    if (myTextView.inputAccessoryView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ShareItemAccessoryView" owner:self options:nil];
        // Loading the AccessoryView nib file sets the accessoryView outlet.
        myTextView.inputAccessoryView = accessoryView;    
        // After setting the accessory view for the text view, we no longer need a reference to the accessory view.
        //self.accessoryView = nil;
    }
	
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    [aTextView resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Responding to keyboard events

- (void)printViews:(NSArray *)views {
	for (UIView* aView in views) {
		NSLog(@"printing %@", [aView class]);
		if ([aView.subviews count])
			[self printViews:aView.subviews];
	}
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
	
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = userInfo[UIKeyboardFrameEndUserInfoKey];
	
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newTextViewFrame = self.view.bounds;
    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    myTextView.frame = newTextViewFrame;
	
    [UIView commitAnimations];
	
	//--
	
//	[self printViews:self.navigationController.navigationBar];
}


- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    myTextView.frame = self.view.bounds;
    
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark HUD delegate business

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

@end