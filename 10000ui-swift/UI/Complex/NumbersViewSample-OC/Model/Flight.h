//
//  Flight.h
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Flight : NSObject

@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *typeOfAircraft;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *placeOfDeparture;
@property (nonatomic, strong) NSString *placeOfDestination;
@property (nonatomic, strong) NSString *departureTime;
@property (nonatomic, strong) NSString *arriveTime;
@property (nonatomic, strong) NSString *price;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
