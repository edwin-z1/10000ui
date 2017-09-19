//
//  BSScrollingLabelView.h
//  blurryssky
//
//  Created by 张亚东 on 15/12/18.
//  Copyright © 2015年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSScrollingLabelView : UIView

///default is 25
@property (nonatomic) IBInspectable CGFloat gradientWidth;

///default is 20
@property (nonatomic) IBInspectable CGFloat labelSpacing;

///default is 50
@property (nonatomic) IBInspectable CGFloat velocity;

///default is 4
@property (nonatomic) IBInspectable NSTimeInterval stayTimeInterval;

///default is system font ,size 17
@property (nullable, nonatomic, strong) UIFont *font;

@property (nullable, nonatomic, strong) IBInspectable UIColor *textColor;

@property (nullable, nonatomic, copy) IBInspectable NSString *text;
@property (nullable, nonatomic, copy) NSAttributedString *attributedText;

@end
