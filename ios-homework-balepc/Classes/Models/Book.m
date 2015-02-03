//
//  Book.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "Book.h"

@implementation Book

#pragma mark - Public

+ (NSString *)cellIdentifier
{
    return @"BookCellIdentifier";
}

- (NSString *)cellIdentifier
{
    return [[self class] cellIdentifier];
}

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
        @keypath(Book.new, bookID): @"id",
        @keypath(Book.new, title): @"title",
        @keypath(Book.new, author): @"author",
        @keypath(Book.new, coverImageURL): @"cover_image"
    };
}

#pragma mark - Model Upgrades

+ (NSUInteger)modelVersion
{
    return 1;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[self class]]) {
        Book *post = object;
        return [post.bookID isEqualToString:self.bookID];
    }
    
    return [super isEqual:object];
}

- (NSUInteger)hash
{
    return self.bookID.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Book - %@, %@ ) ", self.title, self.author];
}

@end
