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

#warning Replace these with your own app credentials
#define kConsumerKey @"D6vneoIuMP0pdBZJAV7gg"
#define kConsumerSecret @"wWc59eahiaES9ZCZ7wp28Rw4hcURG4fmIXvvwJiaR8"

#define kTwitterData @"twitterData"

typedef void(^SCTwitterCallback)(BOOL success);
typedef void(^SCTwitterStatusCallback)(BOOL success, id result);
typedef void(^SCTwitterUserCallback)(BOOL success, id result);
typedef void(^SCTwitterDirectCallback)(BOOL success, id result);


@interface SCTwitter : NSObject

@property (nonatomic, copy) SCTwitterCallback loginCallback;
@property (nonatomic, copy) SCTwitterStatusCallback statusCallback;
@property (nonatomic, copy) SCTwitterUserCallback userCallback;
@property (nonatomic, copy) SCTwitterDirectCallback directCallback;

+ (BOOL)isSessionValid;
+ (void)loginViewControler:(UIViewController *)aViewController callback:(void (^)(BOOL success))aCallback;
+ (void)logoutCallback:(void(^)(BOOL success))aCallback;
+ (void)postWithMessage:(NSString *)message callback:(void (^)(BOOL success, id result))aCallback;
+ (void)getPublicTimelineWithCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserTimelineFor:(NSString *)username sinceID:(unsigned long)sinceID startingAtPage:(int)page count:(int)count callback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserInformationCallback:(void (^)(BOOL success, id result))aCallback;
+ (void)getUserInformationFor:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
+ (void)directMessage:(NSString *)message to:(NSString *)username callback:(void (^)(BOOL success, id result))aCallback;
+ (void)retweetMessage:(NSString *)updateID callback:(void (^)(BOOL success, id result))aCallback;

@end
