//
//  HWBooksNetworkModelTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBooksNetworkModel.h"
#import "HomeWorkAPI.h"
#import "HomeWorkAPI+Books.h"

SpecBegin(HWBooksNetworkModel)

describe(@"network access", ^{
    it(@"gets a list of books", ^{
        Book *book = [Book modelWithJSON:@{
                                     @"id": @"book_id",
                                     @"title": @"book_title",
                                     @"author": @"book_author",
                                     @"cover_image": @"book_coverImageURL"
                                     }];
        
        NSArray *books = @[book];
        
        id APIMock = [OCMockObject mockForClass:[HomeWorkAPI class]];
        id evalutationCheck = [OCMArg checkWithBlock:^BOOL(void (^success)(NSArray *books)) {
            success(books);
            return YES;
        }];
        
        [[[APIMock expect] classMethod] getBooksWithSuccess:evalutationCheck failure:OCMOCK_ANY];
        
        HWBooksNetworkModel *model = [[HWBooksNetworkModel alloc] init];
        
        __block NSArray *returnedBooks;
        [model getBooks:^(NSArray *books) {
            returnedBooks = [books copy];
        } failure:nil];
        
        expect(returnedBooks).to.equal(books);
    });
});

SpecEnd
