//
//  BookTests.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

SpecBegin(Book)

afterEach(^{
    [OHHTTPStubs removeAllStubs];
});

it(@"initialize", ^{
    Book *book = [Book modelWithJSON:@{
                                       @"id": @"book_id",
                                       @"title": @"book_title",
                                       @"author": @"book_author",
                                       @"cover_image": @"book_coverImageURL"
                                       }];
    expect(book.bookID).to.equal(@"book_id");
    expect(book.title).to.equal(@"book_title");
    expect(book.author).to.equal(@"book_author");
    expect(book.coverImageURL).to.equal(@"book_coverImageURL");
});

SpecEnd
