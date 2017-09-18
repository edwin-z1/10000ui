//
//  NSObject+BSNumbers.m
//  BSNumbersSample
//
//  Created by 张亚东 on 16/4/6.
//  Copyright © 2016年 blurryssky. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>

@implementation NSObject (Extension)

- (NSArray<NSString *> *)bs_propertyStringValues {
    
    unsigned int count;
    objc_property_t *cProperties = class_copyPropertyList(self.class, &count);
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t cProperty = cProperties[i];
        
        const char *cName = property_getName(cProperty);
        
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        
        [values addObject:[NSString stringWithFormat:@"%@",[self valueForKey:name]]];
    }
    free(cProperties);
    
    return values.copy;
}


@end
