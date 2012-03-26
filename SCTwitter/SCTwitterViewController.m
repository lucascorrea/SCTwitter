//
//  SCTwitterViewController.m
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 Siriuscode Solutions. All rights reserved.
//

#import "SCTwitterViewController.h"
#import "SCTwitter.h"

@implementation SCTwitterViewController
@synthesize messageText;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Loading
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
	UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingView addSubview:aiView];
	[aiView startAnimating];
	aiView.center =  CGPointMake(160, 240);
	[aiView release];
	[self.view addSubview:loadingView];
	loadingView.hidden = YES;
}

- (void)viewDidUnload
{
    [self setMessageText:nil];
	[super viewDidUnload];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}



#pragma mark - Button Action

- (IBAction)loginButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter loginViewControler:self callback:^(BOOL success){
        loadingView.hidden = YES;
        NSLog(@"Login is Success -  %i", success);
    }];
}

- (IBAction)logoutButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter logoutCallback:^(BOOL success) {
        loadingView.hidden = YES;
        NSLog(@"Logout is Success -  %i", success);        
    }];
}

- (IBAction)postBackgroundButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter postWithMessage:self.messageText.text callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        NSLog(@"Message send -  %i \n%@", success, result);        
    }];
}

- (IBAction)publicTimelineButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter getPublicTimelineWithCallback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
        } 
    }];
}

- (IBAction)userTimelineButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter getUserTimelineFor:@"lucasc0rrea" sinceID:0 startingAtPage:0 count:200 callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
        } 
    }];
}

- (IBAction)userInformationButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter getUserInformationCallback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
        }         
    }];
}

- (IBAction)directMessageButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter directMessage:self.messageText.text to:nil callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
        }else{
            NSLog(@"Error : %@", result);
        }
    }];
}

- (IBAction)retweetButtonAction:(id)sender 
{
    [SCTwitter retweetMessage:nil callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
        }else{
            NSLog(@"%@", result);
        }
    }];
    
}

#pragma mark - 
#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)dealloc {
    [self setMessageText:nil];
    [super dealloc];
}

@end
