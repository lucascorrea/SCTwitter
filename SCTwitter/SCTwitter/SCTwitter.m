//
//  SCTwitter.m
//  SCTwitter
//
//  Created by Lucas Correa on 29/02/12.
//  Copyright (c) 2012 Siriuscode Solutions. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.


#import "SCTwitter.h"

@interface SCTwitter()

- (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success))aCallback;
- (void)logoutCallback:(void (^)(BOOL success))aCallback;
- (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback;
- (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback;
- (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL success, id result))aCallback;
- (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
- (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
- (BOOL)isSessionValid;

@end



@implementation SCTwitter

@synthesize loginCallback;
@synthesize statusCallback;
@synthesize userCallback;
@synthesize directCallback;

#pragma mark -
#pragma mark Singleton

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



#pragma mark - 
#pragma mark Public Methods Class

+ (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success))aCallback
{
    [[SCTwitter shared] loginViewControler:aViewController callback:aCallback];
}

+ (void)logoutCallback:(void (^)(BOOL success))aCallback
{
    [[SCTwitter shared] logoutCallback:aCallback];
}

+ (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] postWithMessage:message callback:aCallback];
}

+ (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getPublicTimelineWithCallback:aCallback];
}

+ (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getUserTimelineFor:username sinceID:sinceID startingAtPage:page count:count callback:aCallback];
}

+ (void)getUserInformationCallback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getUserInformationFor:nil callback:aCallback];
}

+ (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getUserInformationFor:username callback:aCallback];
}

+ (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] directMessage:message to:username callback:aCallback];
}


#pragma mark -
#pragma mark Private Methods

- (BOOL)isSessionValid 
{
    return _engine && [_engine isAuthorized];
}

- (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success))aCallback
{
    if ([self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(YES);
        }
        
    } else {
        // Autorize twitter
        self.loginCallback = aCallback;
        UIViewController *twitterController = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];  
        [aViewController presentModalViewController:twitterController animated: YES];     
    }
}

- (void)logoutCallback:(void (^)(BOOL success))aCallback
{
    [_engine clearAccessToken];
    
    // Remove the stored twitter credentials
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:kTwitterData];
    
    [defaults synchronize];
    
    // Call the logout callback
    if (aCallback) {
        aCallback(YES);
    }
}

- (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, nil);
        }
        
    }else{
        self.statusCallback = aCallback;
        [_engine sendUpdate:[NSString stringWithFormat:@"%@", message]];
    }
}

- (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        self.statusCallback = aCallback;
        [_engine getPublicTimeline];
    }
}

- (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL, id))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        self.statusCallback = aCallback;
        [_engine getUserTimelineFor:username sinceID:sinceID startingAtPage:page count:count];
    }
}

- (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        
        if (username == nil) {
            username = _engine.username;
        }
        
        self.userCallback = aCallback;
        [_engine getUserInformationFor:username];
    }
}

- (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        
        if (username == nil) {
            aCallback(NO, @"No username");
            return;
        }
        
        self.directCallback = aCallback;
        [_engine sendDirectMessage:message to:username];
    }
}

#pragma mark -
#pragma mark - SA_OAuthTwitterControllerDelegate methods

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username 
{
    // Call the login callback
    if (self.loginCallback) {
        self.loginCallback(YES);
        self.loginCallback = nil;
    }
}



#pragma mark -
#pragma mark - SA_OAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username 
{
    
    // Store the twitter credentials
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:data forKey:kTwitterData];
    [defaults synchronize];
    
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username 
{
    
    // Return the last stored auth data (we don't care about username)
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    return [defaults objectForKey:kTwitterData];
}

- (void) twitterOAuthConnectionFailedWithData: (NSData *) data 
{
    NSLog(@"Twitter connection failed");
}



#pragma mark -
#pragma mark - MGTwitterEngineDelegate methods

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
    if (self.statusCallback) {
        self.statusCallback(NO, error);
        self.statusCallback = nil;
    }
    
    if (self.userCallback) {
        self.userCallback(NO, error);
        self.userCallback = nil;
    }
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier
{
    if (self.statusCallback) {
        self.statusCallback(YES, statuses);
        self.statusCallback = nil;
    }
}


- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
    if (self.userCallback) {
        self.userCallback(YES, userInfo);
        self.userCallback = nil;
    }
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier
{
    if (self.directCallback) {
        self.directCallback(YES, messages);
        self.directCallback = nil;
    }
}

@end
