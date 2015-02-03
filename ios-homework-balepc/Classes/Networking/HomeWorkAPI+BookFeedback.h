//
//  HomeWorkAPI+BookFeedback.h
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI.h"

@interface HomeWorkAPI (BookFeedback)

+ (void)createFeedbackForBook:(Book *)book name:(NSString *)name comment:(NSString *)comment success:(void (^)(id message))success failure:(void (^)(NSError *error))failure;

@end
