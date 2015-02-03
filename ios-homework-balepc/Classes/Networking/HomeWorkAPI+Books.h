//
//  HomeWorkAPI+Books.h
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

@interface HomeWorkAPI (Books)

+ (AFJSONRequestOperation *)getBooksWithSuccess:(void (^)(NSArray *books))success failure:(void (^)(NSError *error))failure;

@end
