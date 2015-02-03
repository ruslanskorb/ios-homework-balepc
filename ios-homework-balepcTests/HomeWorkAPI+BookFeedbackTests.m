//
//  HomeWorkAPI+BookFeedbackTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HomeWorkAPI.h"
#import "HomeWorkAPI+BookFeedback.h"
#import "HWNetworkConstants.h"

SpecBegin(HomeWorkAPIBookFeedback)

describe(@"feedback", ^{
    it(@"post feedback for the book", ^{
        Book *book = [Book modelWithJSON:@{
                                           @"id": @"1",
                                           @"title": @"MongoDB: The Definitive Guide",
                                           @"author": @"Kristina Chodorow",
                                           @"cover_image": @"http://akamaicovers.oreilly.com/images/0636920001096/cat.gif"
                                           }];
        NSString *name = @"name";
        NSString *comment = @"comment";
        
        [OHHTTPStubs stubJSONResponseAtPath:[NSString stringWithFormat:HWCreateFeedbackForBookURLFormat, book.bookID]
                               withResponse:@{@"status": @"ok", @"id": book.bookID, @"name": name, @"comment": comment}
                              andStatusCode:201
         ];
        
        __block NSDictionary *result = nil;
        __block BOOL done = NO;
        [HomeWorkAPI createFeedbackForBook:book name:name comment:comment success:^(NSDictionary *message) {
            result = [message copy];
            done = YES;
        } failure:^(NSError *error) {
            XCTFail(@"createFeedbackForBook: %@", error);
            done = YES;
        }];
        
        while(!done) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        expect(result).to.beKindOf([NSDictionary class]);
        expect(result[@"status"]).will.equal(@"ok");
        
        [OHHTTPStubs removeAllStubs];
    });
});

SpecEnd
