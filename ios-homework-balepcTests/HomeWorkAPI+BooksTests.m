//
//  HomeWorkAPI+BooksTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI.h"
#import "HomeWorkAPI+Books.h"
#import "HWNetworkConstants.h"

SpecBegin(HomeWorkAPIBooks)

describe(@"books", ^{
    it(@"gets a list of books", ^{
        [OHHTTPStubs stubJSONResponseAtPath:HWBooksURL
                                 withParams:nil
                               withResponse:@[@{
                                                  @"id": @"1",
                                                  @"title": @"MongoDB: The Definitive Guide",
                                                  @"author": @"Kristina Chodorow",
                                                  @"cover_image": @"http://akamaicovers.oreilly.com/images/0636920001096/cat.gif"
                                                  }]
         ];
        
        __block NSArray *results = nil;
        [HomeWorkAPI getBooksWithSuccess:^(NSArray *books) {
            results = [books copy];
        } failure:nil];
        
        [Expecta setAsynchronousTestTimeout:2];
        expect(results.count).will.equal(1);
        expect([(Book *)results[0] bookID]).will.equal(@"1");
        
        [OHHTTPStubs removeAllStubs];
    });
});

SpecEnd
