//
//  HWRouter.h
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

@interface HWRouter : NSObject

+ (void)setup;

+ (AFHTTPClient *)httpClient;

+ (NSURLRequest *)newBooksRequest;
+ (NSURLRequest *)newCreateFeedbackRequestForBook:(Book *)book name:(NSString *)name comment:(NSString *)comment;

@end
