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

#define TwitterEndpoint @"https://api.twitter.com/1.1/"

@interface SCTwitter()

- (BOOL)isSessionValid;
- (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success, id result))aCallback;
- (void)logoutCallback:(void (^)(BOOL success, id result))aCallback;
- (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback;
- (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback;
- (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL success, id result))aCallback;
- (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
- (void)getFriendsCallback:(void (^)(BOOL success, id result))aCallback;
- (void)getFollowersCallback:(void (^)(BOOL success, id result))aCallback;
- (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
- (void)retweetMessageUpdateID:(NSString *)updateID callback:(void (^)(BOOL success, id result))aCallback;
- (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image latitude:(double)lat longitude:(double)lng callback:(void (^)(BOOL success, id result))aCallback;

@end



@implementation SCTwitter


#pragma mark -
#pragma mark - Singleton


+ (SCTwitter *)shared
{
    static dispatch_once_t pred;
    static SCTwitter *_scTwitter = nil;
    dispatch_once(&pred, ^{ _scTwitter = [[SCTwitter alloc] init]; });
    return _scTwitter;
}



#pragma mark -
#pragma mark - Public Methods

+ (void)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    [[SCTwitter shared] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
}

+ (BOOL)isSessionValid
{
    return [[SCTwitter shared] isSessionValid];
}

+ (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] loginViewControler:aViewController callback:aCallback];
}

+ (void)logoutCallback:(void (^)(BOOL success, id result))aCallback
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

+ (void)getFriendsCallback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getFriendsCallback:aCallback];
}

+ (void)getFollowersCallback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] getFollowersCallback:aCallback];
}

+ (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] directMessage:message to:username callback:aCallback];
}

+ (void)retweetMessageUpdateID:(NSString *)updateID callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] retweetMessageUpdateID:updateID callback:aCallback];
}

+ (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] postWithMessage:message uploadPhoto:image latitude:0 longitude:0 callback:aCallback];
}

+ (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image latitude:(double)lat longitude:(double)lng callback:(void (^)(BOOL success, id result))aCallback
{
    [[SCTwitter shared] postWithMessage:message uploadPhoto:image latitude:lat longitude:lng callback:aCallback];
}




#pragma mark -
#pragma mark - Private Methods

- (void)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret
{
    if (consumerKey.length == 0 || consumerSecret.length == 0) {
        NSLog(@"\n\nMissing your application credentials ConsumerKey and ConsumerSecret. You cannot run the app until you provide this in the code.\n\n");
        return;
    }
    
    [[Twitter sharedInstance] startWithConsumerKey:consumerKey consumerSecret:consumerSecret];
}

- (BOOL)isSessionValid
{
    NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
    self.apiClient = [[TWTRAPIClient alloc] initWithUserID:userID];
    return [Twitter sharedInstance].sessionStore.session;
}

- (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success, id result))aCallback
{
    if ([self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(YES, @"Logged");
        }
        
    } else {
        // Autorize twitter
        self.callback = aCallback;
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                NSString *userID = [Twitter sharedInstance].sessionStore.session.userID;
                self.apiClient = [[TWTRAPIClient alloc] initWithUserID:userID];
                self.callback(YES, @"Logged");
            } else {
                self.callback(NO, error);
            }
        }];
    }
}

- (void)logoutCallback:(void (^)(BOOL success, id result))aCallback
{
    [[Twitter sharedInstance] logOut];
    [[Twitter sharedInstance] logOutGuest];
    
    // Call the logout callback
    if (aCallback) {
        aCallback(YES, @"OK");
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
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@statuses/update.json", TwitterEndpoint];
        NSDictionary *params = @{@"status" : message};
        [self requestWithMethod:@"POST" URL:statusesEndpoint params:params];
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
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@statuses/home_timeline.json", TwitterEndpoint];
        [self requestWithMethod:@"GET" URL:statusesEndpoint params:nil];
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
        self.callback = aCallback;
        
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@statuses/user_timeline.json", TwitterEndpoint];
        NSDictionary *params = @{@"screen_name" : username,
                                 @"count" : [NSString stringWithFormat:@"%d", count]};
        [self requestWithMethod:@"GET" URL:statusesEndpoint params:params];
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
            username = [Twitter sharedInstance].session.userName;
        }
        
        self.callback = aCallback;
        
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@users/show.json", TwitterEndpoint];
        NSDictionary *params = @{@"screen_name" : username,
                                 @"user_id" : [Twitter sharedInstance].sessionStore.session.userID};
        
        [self requestWithMethod:@"GET" URL:statusesEndpoint params:params];
    }
}

- (void)getFriendsCallback:(void (^)(BOOL success, id result))aCallback;
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@friends/ids.json", TwitterEndpoint];
        [self requestWithMethod:@"GET" URL:statusesEndpoint params:nil];
    }
}

- (void)getFollowersCallback:(void (^)(BOOL success, id result))aCallback;
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@followers/ids.json", TwitterEndpoint];
        [self requestWithMethod:@"GET" URL:statusesEndpoint params:nil];
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
            aCallback(NO, @"No username entered for Direct Message");
            return;
        }
        
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@direct_messages/new.json", TwitterEndpoint];
        NSDictionary *params = @{@"text" : message,
                                 @"screen_name" : username};
        [self requestWithMethod:@"POST" URL:statusesEndpoint params:params];
    }
}

- (void)retweetMessageUpdateID:(NSString *)updateID callback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        
        if (updateID == nil) {
            aCallback(NO, @"No updateID");
            return;
        }
        
        self.callback = aCallback;
        NSString *statusesEndpoint = [NSString stringWithFormat:@"%@statuses/retweets/%@.json", TwitterEndpoint, updateID];
        [self requestWithMethod:@"POST" URL:statusesEndpoint params:nil];
    }
}

- (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image latitude:(double)lat longitude:(double)lng callback:(void (^)(BOOL success, id result))aCallback
{
    if (![self isSessionValid]) {
        
        // Call the login callback if we have one
        if (aCallback) {
            aCallback(NO, @"Error");
        }
        
    }else{
        
        self.callback = aCallback;
        NSString *media = @"https://upload.twitter.com/1.1/media/upload.json";
        NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
        NSString *imageString = [imageData base64EncodedStringWithOptions:0];
        
        NSError *clientError;
        NSURLRequest *request = [self.apiClient URLRequestWithMethod:@"POST" URL:media parameters:@{@"media":imageString} error:&clientError];
        
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *urlResponse, NSData *data, NSError *connectionError) {
            
            NSError *jsonError;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            
            NSString *statusesEndpoint = [NSString stringWithFormat:@"%@statuses/update.json", TwitterEndpoint];
            NSDictionary *params = @{@"status" : message,
                                     @"lat": [NSString stringWithFormat:@"%f", lat],
                                     @"long": [NSString stringWithFormat:@"%f", lng],
                                     @"media_ids" : json[@"media_id_string"]};
            [self requestWithMethod:@"POST" URL:statusesEndpoint params:params];
            
        }];
    }
}


- (void)requestWithMethod:(NSString *)method URL:(NSString *)url params:(NSDictionary *)params
{
    NSError *clientError;
    NSURLRequest *request = [self.apiClient URLRequestWithMethod:method URL:url parameters:params error:&clientError];
    
    if (request) {
        [self.apiClient sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                NSError *jsonError;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                self.callback(YES, json);
            } else {
                self.callback(NO, connectionError);
            }
        }];
    }else {
        self.callback(NO, clientError);
    }
}

@end
