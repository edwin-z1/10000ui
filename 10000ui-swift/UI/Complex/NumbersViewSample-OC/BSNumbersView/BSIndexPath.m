//
//  BSIndexPath.m
//  10000ui-swift
//
//  Created by 张亚东 on 09/10/2017.
//  Copyright © 2017 blurryssky. All rights reserved.
//

#import "BSIndexPath.h"

@implementation BSIndexPath

+ (instancetype)indexPathForColumn:(NSInteger)column inRow:(NSInteger)row {
    BSIndexPath *indexPath = [BSIndexPath new];
    indexPath->_column = column;
    indexPath->_row = row;
    return indexPath;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"row = %ld, column = %ld", (long)self.row, (long)self.column];
}

@end
