//
//  HomeWorkAPI+BookFeedback.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI+BookFeedback.h"
#import "HomeWorkAPI+Private.h"

@implementation HomeWorkAPI (BookFeedback)

+ (void)createFeedbackForBook:(Book *)book name:(NSString *)name comment:(NSString *)comment success:(void (^)(id message))success failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [HWRouter newCreateFeedbackRequestForBook:book name:name comment:comment];
    [self performRequest:request success:success failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
