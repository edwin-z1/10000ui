//
//  NSString+BSNumbers.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "NSString+BSNumbers.h"

@implementation NSString (BSNumbers)

- (CGSize)bs_sizeWithFont:(UIFont *)font constraint:(CGSize)constraint {
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    CGRect bounds = [self boundingRectWithSize:constraint options:options attributes:attributes context:nil];
    CGSize size = bounds.size;
    return size;
}

@end
