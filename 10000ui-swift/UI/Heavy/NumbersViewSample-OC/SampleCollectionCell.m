//
//  SampleCollectionCell.m
//  BSNumbersSample
//
//  Created by 张亚东 on 02/05/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

#import "SampleCollectionCell.h"

@interface SampleCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *customLabel;

@end

@implementation SampleCollectionCell

- (void)setString:(NSString *)string {
    _customLabel.text = string;
}

@end
