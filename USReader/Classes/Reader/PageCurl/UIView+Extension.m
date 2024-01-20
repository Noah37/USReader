//
//  UIView+Extension.m
//  USReader
//
//  Created by nongyun.cao on 2023/12/6.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (UIImage *)screenShot {
    CGSize size = self.bounds.size;
    CGAffineTransform transform = CGAffineTransformMake(-1, 0, 0, 1, size.width, 0);
    UIGraphicsBeginImageContextWithOptions(size, self.isOpaque, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    [self.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
