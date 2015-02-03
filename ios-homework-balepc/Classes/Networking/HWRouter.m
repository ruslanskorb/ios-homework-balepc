//
//  HWRouter.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWRouter.h"
#import "HWNetworkConstants.h"

static AFHTTPClient *_staticHTTPClient = nil;

@implementation HWRouter

+ (void)setup
{
    [HWRouter setupWithBaseApiURL:[HWRouter baseApiURL]];
    [self setupUserAgent];
}

+ (NSURL *)baseApiURL
{
    return [NSURL URLWithString:HWBaseApiURL];
}

+ (void)setupWithBaseApiURL:(NSURL *)baseApiURL
{
    _staticHTTPClient = [AFHTTPClient clientWithBaseURL:baseApiURL];
    
    [_staticHTTPClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: {
                break; // do nothing
            }
            case AFNetworkReachabilityStatusNotReachable: {
                [[NSNotificationCenter defaultCenter] postNotificationName:HWNetworkUnavailableNotification object:nil];
                break;
            }
            default: {
                [[NSNotificationCenter defaultCenter] postNotificationName:HWNetworkAvailableNotification object:nil];
                break;
            }
        }
    }];
}

+ (void)setupUserAgent
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *header = [_staticHTTPClient defaultValueForHeader:@"User-Agent"];
    NSString *agentString = [NSString stringWithFormat:@"HW-Mobile/%@ ios-homework-balepc/%@", version, build];
    NSString *userAgent = [header stringByReplacingOccurrencesOfString:@"ios-homework-balepc" withString:agentString];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{ @"UserAgent" : userAgent } ];
    [_staticHTTPClient setDefaultHeader:@"User-Agent" value:userAgent];
}

+ (AFHTTPClient *)httpClient
{
    return _staticHTTPClient;
}

#pragma mark - Books

+ (NSURLRequest *)newBooksRequest
{
    return [_staticHTTPClient requestWithMethod:@"GET" path:HWBooksURL parameters:nil];
}

#pragma mark - Feedback

+ (NSURLRequest *)newCreateFeedbackRequestForBook:(Book *)book name:(NSString *)name comment:(NSString *)comment
{
    NSString *path = [NSString stringWithFormat:HWCreateFeedbackForBookURLFormat, book.bookID];
    NSDictionary *parameters = @{@"id": book.bookID, @"name": name, @"comment": comment};
    return [_staticHTTPClient requestWithMethod:@"POST" path:path parameters:parameters];
}

@end
