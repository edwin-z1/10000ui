//
//  UIImage+BSCategory.h
//  Objective-C_Categories
//
//  Created by 张亚东 on 16/7/22.
//  Copyright © 2016年 张亚东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BSCategory)

NS_ASSUME_NONNULL_BEGIN

#pragma mark - generating

/// Returns A new image created from GIF, you can access the images via property '.images'.
+ (instancetype)bs_imageWithGIFData:(NSData *)data;

NS_ASSUME_NONNULL_END

@end
