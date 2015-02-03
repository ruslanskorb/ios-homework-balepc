//
// Copyright (c) 2015 Artsy Inc.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "UIImageView+AsyncImageLoading.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UIImageView (AsyncImageLoading)

- (void)ar_setImageWithURL:(NSURL *)url
{
    UIImage *placeholder = [UIImage imageFromColor:[UIColor rsk_lightGrayColor]];
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}

- (void)ar_setImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completed
{
    UIImage *placeholder = [UIImage imageFromColor:[UIColor rsk_lightGrayColor]];
    [self sd_setImageWithURL:url placeholderImage:placeholder completed:completed];
}

- (void)ar_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    if (!placeholder) {
        placeholder = [UIImage imageFromColor:[UIColor rsk_lightGrayColor]];
    }
    
    [self sd_setImageWithURL:url placeholderImage:placeholder];
}


@end
