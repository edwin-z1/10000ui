//
//  BSNumbersCollectionHeaderView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/7.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSNumbersViewEnum.h"

@interface BSNumbersCollectionHeaderView : UICollectionReusableView

@property (nonatomic) BSNumbersSeparatorStyle rowSeparatorStyle;
@property (nonatomic, strong) UIColor *rowSeparatorColor;

@end
