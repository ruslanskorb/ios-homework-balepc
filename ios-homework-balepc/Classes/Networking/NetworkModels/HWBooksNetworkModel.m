//
//  HWBooksNetworkModel.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBooksNetworkModel.h"

@interface HWBooksNetworkModel ()

@property (assign, nonatomic) BOOL allDownloaded;
@property (assign, nonatomic) BOOL downloadLock;

@end

@implementation HWBooksNetworkModel

- (void)getBooks:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    if (self.downloadLock) {
        return;
    }
    
    self.downloadLock = YES;
    
    [HomeWorkAPI getBooksWithSuccess:^(NSArray *books) {
        self.downloadLock = NO;
        
        self.allDownloaded = YES;
        
        if(success) {
            success(books);
        }
    } failure:^(NSError *error) {
        self.downloadLock = NO;
        
        self.allDownloaded = YES;
        
        if(success) {
            success(@[]);
        }
    }];
}

@end
