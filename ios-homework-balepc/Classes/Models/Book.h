//
//  Book.h
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "MTLModel.h"

@interface Book : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly, copy) NSString *bookID;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *author;
@property (nonatomic, readonly, copy) NSString *coverImageURL;

+ (NSString *)cellIdentifier;

- (NSString *)cellIdentifier;

@end
