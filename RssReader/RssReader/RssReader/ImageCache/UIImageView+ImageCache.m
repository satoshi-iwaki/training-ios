/*!
 *@file		UIImageView+ImageCache.m
 *@brief	UIImageView+ImageCache実装ファイル
 *@author	Satoshi Iwaki
 *@date		2013/05/16
 */

#import "UIImageView+ImageCache.h"
#import "ImageCache.h"

@implementation UIImageView (ImageCache)

- (void)cachedImage:(UIImage *)image
{
    self.image = image;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)setImageURL:(NSURL *)URL
{
    self.image = [ImageCache defaultImage];
    
    [[ImageCache sharedInstance] getImageForURL:URL completionHandler:^(UIImage * _Nonnull image) {
        self.image = image;
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }];
//    [[ImageCache sharedInstance] imageForURL:URL
//                                      target:self
//                                    selector:@selector(cachedImage:)];
}

@end
