//
//  HomeWorkAPI.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI.h"
#import "HomeWorkAPI+Private.h"

@implementation HomeWorkAPI

+ (AFJSONRequestOperation *)performRequest:(NSURLRequest *)request success:(void (^)(id))success failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    NSParameterAssert(success);
    
    __weak AFJSONRequestOperation *performOperation = nil;
    performOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^ (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        success(JSON);
    } failure:^ (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(request, response, error);
        }
    }];
    
    [performOperation start];
    return performOperation;
}

+ (AFJSONRequestOperation *)getRequest:(NSURLRequest *)request parseIntoAClass:(Class)aClass success:(void (^)(id))success failure:(void (^)(NSError *error))failure {
    return [self getRequest:request parseIntoAClass:aClass withKey:nil success:success failure:failure];
}

+ (AFJSONRequestOperation *)getRequest:(NSURLRequest *)request parseIntoAnArrayOfClass:(Class)aClass success:(void (^)(NSArray *))success failure:(void (^)(NSError *error))failure {
    return [self getRequest:request parseIntoAnArrayOfClass:aClass withKey:nil success:success failure:failure];
}

+ (AFJSONRequestOperation *)getRequest:(NSURLRequest *)request parseIntoAClass:(Class)aClass withKey:(NSString *)key success:(void (^)(id))success failure:(void (^)(NSError *error))failure
{
    __weak AFJSONRequestOperation *getOperation = nil;
    getOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^ (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSDictionary *jsonDictionary = JSON;
        id object = nil;
        if (key) {
            if (jsonDictionary[key]) {
                object = [aClass modelWithJSON:jsonDictionary[key] error:nil];
            }
        } else {
            NSError *error = nil;
            object = [aClass modelWithJSON:jsonDictionary error:&error];
            NSLog(@"%@", error.localizedDescription);
        }
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(object);
            });
        }
    } failure:^ (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failure) {
            failure(error);
        }
    }];
    getOperation.successCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [getOperation start];
    return getOperation;
}

+ (AFJSONRequestOperation *)getRequest:(NSURLRequest *)request parseIntoAnArrayOfClass:(Class)aClass withKey:(NSString *)key success:(void (^)(NSArray *))success failure:(void (^)(NSError *error))failure {
    NSParameterAssert(success);
    
    __weak AFJSONRequestOperation *getOperation = nil;
    getOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^ (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSArray *jsonDictionaries = JSON;
        NSMutableArray *returnArray = [NSMutableArray array];
        
        for (NSDictionary *dictionary in jsonDictionaries) {
            id object = nil;
            if (![dictionary isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            if (key) {
                if ([dictionary.allKeys containsObject:key]) {
                    object = [aClass modelWithJSON:dictionary[key] error:nil];
                }
            } else {
                object = [aClass modelWithJSON:dictionary error:nil];
            }
            
            if (object) {
                [returnArray addObject:object];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(returnArray);
        });
    }
                                                                   failure:^ (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                       if (failure) {
                                                                           failure(error);
                                                                       }
                                                                   }];
    getOperation.successCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [getOperation start];
    return getOperation;
}

+ (AFJSONRequestOperation *)getRequest:(NSURLRequest *)request parseIntoAnArrayOfClass:(Class)aClass fromDictionaryWithKey:(NSString *)key success:(void (^)(NSArray *))success failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(success);
    
    __weak AFJSONRequestOperation *getOperation = nil;
    getOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^ (NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSMutableArray *returnArray = [NSMutableArray array];
        
        NSArray *jsonDictionaries = JSON[key];
        for (NSDictionary *dictionary in jsonDictionaries) {
            id object = [aClass modelWithJSON:dictionary error:nil];
            
            if (object) {
                [returnArray addObject:object];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            success(returnArray);
        });
    }
                                                                   failure:^ (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                                       if (failure) {
                                                                           failure(error);
                                                                       }
                                                                   }];
    getOperation.successCallbackQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    [getOperation start];
    return getOperation;
}

@end
