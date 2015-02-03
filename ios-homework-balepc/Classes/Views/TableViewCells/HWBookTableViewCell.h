//
//  HWBookTableViewCell.h
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWBookTableViewCell : UITableViewCell

/// Configure the cell with the book.
- (void)configureWithBook:(Book *)book;

@end
