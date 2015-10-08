//
//  SCTwitterViewController.m
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 Siriuscode Solutions. All rights reserved.
//

#import "SCTwitterViewController.h"
#import "SCTwitter.h"

#define SCAlert(title,msg) [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];

@implementation SCTwitterViewController

@synthesize messageText;


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Loading
    loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
	UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[loadingView addSubview:aiView];
	[aiView startAnimating];
	aiView.center =  loadingView.center;
	[aiView release];
	[self.view addSubview:loadingView];
	loadingView.hidden = YES;
}

- (void)viewDidUnload
{
    [self setMessageText:nil];
    [self setBackground:nil];
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
    
    [SCTwitter loginViewControler:self callback:^(BOOL success, id result){
        loadingView.hidden = YES;
        if (success) {
            NSLog(@"Login is Success -  %i", success);
            SCAlert(@"Alert", @"Success");            
        }
    }];
}

- (IBAction)logoutButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter logoutCallback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        NSLog(@"Logout is Success -  %i", success);        
        SCAlert(@"Alert", @"Logout successfully");
    }];
}

- (IBAction)postBackgroundButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter postWithMessage:@"Test upload image" uploadPhoto:[UIImage imageNamed:@"Default"] latitude:-46.0123 longitude:-23.5133 callback:^(BOOL success, id result) {
        
//    [SCTwitter postWithMessage:self.messageText.text callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        if (success) {
            NSLog(@"Message send -  %i \n%@", success, result); 
            SCAlert(@"Alert", @"Send message in background");            
        }else {
            SCAlert(@"Alert", @"Not Login");            
        }
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
            SCAlert(@"Alert", @"Request public timeline success");
        }else {
            SCAlert(@"Alert", @"Not Login");   
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
                SCAlert(@"Alert", @"Request user timeline success");
        }else {
            SCAlert(@"Alert", @"Not Login");   
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
            SCAlert(@"Alert", @"Request user information success");   
        }else {
            SCAlert(@"Alert", @"Not Login");   
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
            SCAlert(@"%@", result);
        }else{
            NSLog(@"Error : %@", result);
            SCAlert(@"Alert", result);
        }
    }];
}

- (IBAction)retweetButtonAction:(id)sender 
{
    loadingView.hidden = NO;
    
    [SCTwitter retweetMessageUpdateID:nil callback:^(BOOL success, id result) {
        loadingView.hidden = YES;
        
        if (success) {
            //Return array NSDictonary
            NSLog(@"%@", result);
            SCAlert(@"Alert", @"Request retweet success");   
        }else{
            NSLog(@"%@", result);
            SCAlert(@"Alert", @"Error retweet");   
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
    [_background release];
    [super dealloc];
}

@end
