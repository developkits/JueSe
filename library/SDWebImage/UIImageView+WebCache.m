/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    /*
    CGRect frame=CGRectZero;
    CGSize imageSize=[image size];
    CGSize superSize=[[UIScreen mainScreen] bounds].size;
    if(imageSize.height/imageSize.width<=superSize.height/superSize.width)
    {
        frame=CGRectMake(0, 0, superSize.width, imageSize.height*(superSize.width/imageSize.width));
        NSLog(@"1");
    }
    else
    {
        NSLog(@"2");
        frame=CGRectMake(0, 0, imageSize.width*(superSize.height/imageSize.height), superSize.height);
    }
//    NSLog(@"superFrame:%@",NSStringFromCGRect(self.superview.frame));
//    NSLog(@"imageSize:%@",NSStringFromCGSize(imageSize));
//    NSLog(@"frame1:%@",NSStringFromCGRect(frame));
   // self.frame=frame;
   // self.center=CGPointMake(superSize.width/2, superSize.height/2);
     */
    self.image = image;
}

@end
