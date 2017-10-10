//
//  NSString+BSNumbersView.m
//  10000ui-swift
//
//  Created by 张亚东 on 09/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

#import "NSString+BSNumbersView.h"

@implementation NSString (BSNumbersView)

- (CGSize)bs_sizeWithFont:(UIFont *)font constraint:(CGSize)constraint {
    
    NSStringDrawingOptions options = NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin;
    NSDictionary *attributes = @{ NSFontAttributeName: font };
    CGRect bounds = [self boundingRectWithSize:constraint options:options attributes:attributes context:nil];
    CGSize size = bounds.size;
    return size;
}

@end
