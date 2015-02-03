//
//  HWBookTableViewCell.m
//  ios-homework-balepc
//
//  Created by Ruslan Skorb on 2/2/15.
//  Copyright (c) 2015 Ruslan Skorb. All rights reserved.
//

#import "HWBookTableViewCell.h"

@interface HWBookTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@end

@implementation HWBookTableViewCell

- (void)configureWithBook:(Book *)book
{
    self.titleLabel.text = book.title;
    self.authorLabel.text = book.author;
    [self.coverImageView ar_setImageWithURL:[NSURL URLWithString:book.coverImageURL]];
}

@end
