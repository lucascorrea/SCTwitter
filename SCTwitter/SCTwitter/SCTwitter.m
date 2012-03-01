//
//  SCTwitter.m
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SCTwitter.h"

@interface SCTwitter()

- (void)loginViewControler:(UIViewController *)aViewController callBack:(void (^)(BOOL success, id result))aCallBack;
- (BOOL)isSessionValid;

@end

@implementation SCTwitter

@synthesize loginCallback;

static SCTwitter *_scTwitter = nil;

+ (SCTwitter *)shared {
    
    @synchronized (self){
        
        static dispatch_once_t pred;
        
        dispatch_once(&pred, ^{
            _scTwitter = [[SCTwitter alloc] init];
        });
    }
    
    return _scTwitter;
}

- (SCTwitter *) init
{
	self = [super init];
	if (self != nil){
        
        // Initialize Twitter
        _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];  
        _engine.consumerKey    = kConsumerKey;
        _engine.consumerSecret = kConsumerSecret;
    
    }
	return self;
}


+ (void)loginViewControler:(UIViewController *)aViewController callBack:(void (^)(BOOL, id))aCallBack
{
    [[SCTwitter shared] loginViewControler:aViewController callBack:aCallBack];
}

- (void)loginViewControler:(UIViewController *)aViewController callBack:(void (^)(BOOL, id))aCallBack
{
    if ([self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallBack) {
            aCallBack(YES, nil);
        }
        
    } else {
        // Autorize twitter
        
        self.loginCallback = aCallBack;
        UIViewController *twitterController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        [aViewController presentModalViewController:twitterController animated: YES];     
    }
}

- (BOOL)isSessionValid 
{
    return _engine && [_engine isAuthorized];
}


- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    
    // Call the login callback
    if (self.loginCallback) {
        self.loginCallback(YES, nil);
    }
    
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    
//    if (messageSuccessCallback) {
//        messageSuccessCallback();
//    }
    
}


- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
    
    // Store the twitter credentials
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:@"twitter_oauth_data"];
    [defaults synchronize];
    
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
    
    // Return the last stored auth data (we don't care about username)
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:@"twitter_oauth_data"];
    return nil;
}

- (void) twitterOAuthConnectionFailedWithData: (NSData *) data {
    NSLog(@"Twitter connection failed");
}

@end
