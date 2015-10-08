//
//  SCTwitter.h
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

#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>


typedef void(^SCTwitterCallback)(BOOL success, id result);

@interface SCTwitter : NSObject

@property (nonatomic, copy) SCTwitterCallback callback;
@property (strong, nonatomic) TWTRAPIClient *apiClient;

+ (void)initWithConsumerKey:(NSString *)consumerKey consumerSecret:(NSString *)consumerSecret;
+ (BOOL)isSessionValid;
+ (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success, id result))aCallback;
+ (void)logoutCallback:(void(^)(BOOL success, id result))aCallback;
+ (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback;
+ (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserInformationCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
+ (void)getFriendsCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)getFollowersCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
+ (void)retweetMessageUpdateID:(NSString *)updateID callback:(void (^)(BOOL success, id result))aCallback;
+ (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image callback:(void (^)(BOOL success, id result))aCallback;
+ (void)postWithMessage:(NSString *)message uploadPhoto:(UIImage *)image latitude:(double)lat longitude:(double)lng callback:(void (^)(BOOL success, id result))aCallback;

@end
