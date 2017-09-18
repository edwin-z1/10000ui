//
//  NumbersViewController.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "NumbersViewController.h"
#import "Flight.h"
#import "BSNumbersView.h"
#import "NSObject+Extension.h"
#import "SampleCollectionCell.h"

NSString * const SampleCollectionCellReuseIdentifier = @"SampleCollectionCellReuseIdentifier";

@interface NumbersViewController () <BSNumbersViewDelegate, BSNumbersViewDataSource>

@property (weak, nonatomic) IBOutlet BSNumbersView *numbersView;
@property (nonatomic, strong) NSArray<Flight *> *flights;
@property (nonatomic, strong) NSArray<NSString *> *headerData;

@end

@implementation NumbersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"航班信息";
    
    NSArray<NSDictionary *> *flightsInfo = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flightsInfo" ofType:@"plist"]];
    
    NSMutableArray<Flight *> *flights = @[].mutableCopy;
    for (NSDictionary *flightInfo in flightsInfo) {
        Flight *flight = [[Flight alloc]initWithDictionary:flightInfo];
        [flights addObject:flight];
    }
    _flights = flights.copy;
    
    _headerData = @[@"Flight Company", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];

//    _numbersView.columnsToFreeze = 3;
    _numbersView.itemMaxWidth = 300;
    _numbersView.itemMinWidth = 100;
    _numbersView.rowHeight = 50;

    _numbersView.isFreezeFirstRow = YES;
    _numbersView.delegate = self;
    _numbersView.dataSource = self;
    
    [_numbersView registerNib:[UINib nibWithNibName:@"SampleCollectionCell" bundle:nil] forCellWithReuseIdentifier:SampleCollectionCellReuseIdentifier];
    //添加边界线
//    _numbersView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _numbersView.layer.borderWidth = 0.5;
    
    [_numbersView reloadData];
}

#pragma mark - BSNumbersViewDataSource

- (NSInteger)numberOfColumnsInNumbersView:(BSNumbersView *)numbersView {
//    return _headerData.count;
    return _flights.firstObject.bs_propertyStringValues.count;
}

- (NSInteger)numberOfRowsInNumbersView:(BSNumbersView *)numbersView {
    // +1是headerData
    return _flights.count + 1;
}

- (NSAttributedString *)numbersView:(BSNumbersView *)numbersView attributedStringForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *string = nil;
    if (indexPath.row == 0) {
        string = _headerData[indexPath.column];
    } else {
        string = _flights[indexPath.row - 1].bs_propertyStringValues[indexPath.column];
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
    return attributedString;
}

- (UICollectionViewCell *)numbersView:(BSNumbersView *)numbersView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        if (indexPath.column == 1) {
            SampleCollectionCell *cell = [numbersView dequeueReusableCellWithReuseIdentifier:SampleCollectionCellReuseIdentifier forIndexPath:indexPath];
            cell.string = _flights[indexPath.row - 1].bs_propertyStringValues[indexPath.column];
            return cell;
        }
    }
    return nil;
}

#pragma mark -- BSNumbersViewDelegate

- (CGFloat)numbersView:(BSNumbersView *)numbersView heightForRow:(NSInteger)row {
    if (row % 2 == 1) {
        return 50;
    } else {
        return 100;
    }
}

- (CGFloat)numbersView:(BSNumbersView *)numbersView widthForColumn:(NSInteger)column {
    if (column == 1) {
        return 150;
    } else {
        return BSNumbersViewAutomaticDimension;
    }
}

- (void)numbersView:(BSNumbersView *)numbersView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", indexPath.bs_description);
    
    _headerData = @[@"???", @"Flight Number", @"Type Of Aircraft", @"Date", @"Place Of Departure", @"Place Of Destination", @"Departure Time", @"Arrive Time", @"Price"];
    NSIndexPath *indexPathToReload = [NSIndexPath indexPathForColumn:0 inRow:0];
    [numbersView reloadItemsAtIndexPaths:@[indexPathToReload]];
    
    //if someone need to modify the text, you can use UIAlertController to alert modify text,
    //then use - (void)reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
}

@end
