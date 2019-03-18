//
//  UIImage+BSCategory.m
//  Objective-C_Categories
//
//  Created by 张亚东 on 16/7/22.
//  Copyright © 2016年 张亚东. All rights reserved.
//

#import "UIImage+BSCategory.h"

@implementation UIImage (BSCategory)

#pragma mark - generating

+ (instancetype)bs_imageWithGIFData:(NSData *)data {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    UIImage *animatedImage;
    if (count <= 1) {
        animatedImage = [[UIImage alloc] initWithData:data];
    } else {
        
        NSMutableArray *images = [NSMutableArray array];
        
        NSTimeInterval duration = 0.0f;
        
        for (size_t i = 0; i < count; i++) {
            
            CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, i, NULL);
            
            if (!imageRef) {
                continue;
            }
            
            @autoreleasepool {
                
                CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
                
                CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
                
                BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                              
                                              imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                              
                                              imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                              
                                              imageColorSpaceModel == kCGColorSpaceModelIndexed);
                
                if (unsupportedColorSpace) {
                    
                    colorspaceRef = CGColorSpaceCreateDeviceRGB();
                    
                    CFAutorelease(colorspaceRef);
                    
                }
                
                size_t width = CGImageGetWidth(imageRef);
                
                size_t height = CGImageGetHeight(imageRef);
                
                size_t bytesPerRow = 4 * width;
                
                CGContextRef context = CGBitmapContextCreate(NULL,width,height,8,bytesPerRow,colorspaceRef,kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
                
                if (context != NULL) {
                    
                    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
                    
                    CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
                    
                    CGContextRelease(context);
                    
                    CGImageRelease(imageRef);
                    
                    imageRef = imageRefWithoutAlpha;
                    
                }
                
            }
            
            float frameDuration = 0.1f;
            
            CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil);
            
            NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
            
            NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
            
            NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            if (delayTimeUnclampedProp) {
                
                frameDuration = [delayTimeUnclampedProp floatValue];
                
            } else {
                
                NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
                
                if (delayTimeProp) {
                    frameDuration = [delayTimeProp floatValue];
                }
                
            }
            
            CFRelease(cfFrameProperties);
            
            duration += frameDuration;
            
            UIImage *image = [UIImage imageWithCGImage:imageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
            if (image) {
                [images addObject:image];
            }
            CGImageRelease(imageRef);
            
        }
        
        if (!duration) {
            duration = (1.0f / 10.0f) * count;
        }
        
        animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    }
    CFRelease(source);
    return animatedImage;
}

@end
