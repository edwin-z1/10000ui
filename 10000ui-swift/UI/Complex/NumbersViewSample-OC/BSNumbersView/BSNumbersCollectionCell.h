//
//  BSNumbersCollectionCell.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import "BSNumbersViewEnum.h"

@interface BSNumbersCollectionCell : UICollectionViewCell

@property (nonatomic) CGFloat textHorizontalMargin;

- (void)setAttributedString:(NSAttributedString *)attributedString;

@end
