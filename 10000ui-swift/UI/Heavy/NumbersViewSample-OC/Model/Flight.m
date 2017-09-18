//
//  Flight.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "Flight.h"

@implementation Flight

- (instancetype)initWithDictionary:(NSDictionary *)dic {

    self = [super init];
    if (self) {
        for (NSString *key in dic) {
            [self setValue:dic[key] forKey:key];
        }
    }
    return self;

}

@end
