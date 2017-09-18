//
//  BSNumbersView.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSNumbersViewEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class BSNumbersView;

@protocol BSNumbersViewDataSource<NSObject>

@required
- (NSInteger)numberOfRowsInNumbersView:(BSNumbersView *)numbersView;
- (NSInteger)numberOfColumnsInNumbersView:(BSNumbersView *)numbersView;
- (__kindof NSAttributedString * _Nullable)numbersView:(BSNumbersView *)numbersView attributedStringForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (__kindof UICollectionViewCell * _Nullable)numbersView:(BSNumbersView *)numbersView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol BSNumbersViewDelegate<NSObject>

@optional
- (CGFloat)numbersView:(BSNumbersView *)numbersView heightForRow:(NSInteger)row;
- (CGFloat)numbersView:(BSNumbersView *)numbersView widthForColumn:(NSInteger)column;
- (void)numbersView:(BSNumbersView *)numbersView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

///automatic caculate width, base on text length and textHorizontalMargin
UIKIT_EXTERN const CGFloat BSNumbersViewAutomaticDimension;

@interface BSNumbersView : UIView

@property (nonatomic, weak, nullable) IBInspectable id<BSNumbersViewDataSource> dataSource;
@property (nonatomic, weak, nullable) IBInspectable id<BSNumbersViewDelegate> delegate;

///the columns need to freeze, default is 1
@property (nonatomic) IBInspectable NSInteger columnsToFreeze;
///if the first row needs to freeze, default is NO
@property (nonatomic) IBInspectable BOOL isFreezeFirstRow;

///default is BSNumbersSeparatorStyleSolid
@property (nonatomic) IBInspectable BSNumbersSeparatorStyle rowSeparatorStyle;
@property (nonatomic, strong) IBInspectable UIColor *rowSeparatorColor;

@property (nonatomic) IBInspectable BSNumbersSeparatorStyle columnSeparatorStyle;
@property (nonatomic, strong) IBInspectable UIColor *columnSeparatorColor;

- (void)reloadData;
- (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

///default is 100
@property (nonatomic) IBInspectable CGFloat itemMinWidth;
///default is 150
@property (nonatomic) IBInspectable CGFloat itemMaxWidth;
///default is 50
@property (nonatomic) IBInspectable CGFloat rowHeight;
///default is 10
@property (nonatomic) IBInspectable CGFloat textHorizontalMargin;

/* if - (__kindof UICollectionViewCell *)numbersView:(BSNumbersView *)numbersView cellForItemAtIndexPath:(NSIndexPath *)indexPath;  need to implementation, register cell first.
*/
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSIndexPath (BSNumbersView)

+ (instancetype)indexPathForColumn:(NSInteger)column inRow:(NSInteger)row;

@property (nonatomic, readonly) NSInteger column;

- (NSString *)bs_description;

@end

NS_ASSUME_NONNULL_END
