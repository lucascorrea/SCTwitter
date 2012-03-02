//
//  SCTwitterViewController.h
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 Siriuscode Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTwitterViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *messageText;

- (IBAction)loginButtonAction:(id)sender;
- (IBAction)logoutButtonAction:(id)sender;
- (IBAction)postBackgroundButtonAction:(id)sender;
- (IBAction)publicTimelineButtonAction:(id)sender;
- (IBAction)userTimelineButtonAction:(id)sender;
- (IBAction)userInformationButtonAction:(id)sender;
- (IBAction)directMessageButtonAction:(id)sender;

@end
