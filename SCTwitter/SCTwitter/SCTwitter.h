//
//  SCTwitter.h
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"

#warning Your application App ID/API Key Twitter
#define kConsumerKey @"D6vneoIuMP0pdBZJAV7gg"
#define kConsumerSecret @"wWc59eahiaES9ZCZ7wp28Rw4hcURG4fmIXvvwJiaR8"


typedef void(^SCTwitterCallback)(BOOL success, id result);

@interface SCTwitter : NSObject <SA_OAuthTwitterEngineDelegate, SA_OAuthTwitterControllerDelegate>{
    SA_OAuthTwitterEngine *_engine;
    UIViewController *_viewController;
    
}

@property (nonatomic, copy) SCTwitterCallback loginCallback;

+ (SCTwitter *)shared;
+ (void)loginViewControler:(UIViewController *)aViewController callBack:(void (^)(BOOL success, id result))aCallBack;
//+ (void)logoutCallBack:(void(^)(BOOL success, id result))callBack;

@end
