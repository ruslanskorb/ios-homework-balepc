//
//  HomeWorkAPI+Books.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI+Books.h"
#import "HomeWorkAPI+Private.h"

@implementation HomeWorkAPI (Books)

+ (AFJSONRequestOperation *)getBooksWithSuccess:(void (^)(NSArray *books))success failure:(void (^)(NSError *error))failure
{
    NSURLRequest *request = [HWRouter newBooksRequest];
    return [self getRequest:request parseIntoAnArrayOfClass:Book.class success:success failure:failure];
}

@end
