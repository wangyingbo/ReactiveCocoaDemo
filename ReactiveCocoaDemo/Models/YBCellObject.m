//
//  YBCellObject.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/2.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "YBCellObject.h"
#import "YBCellObject+Private.h"

@implementation YBCellObject

+ (instancetype)objectWithCellClass:(Class)cellClass {
    YBCellObject *cellObject = [[YBCellObject alloc] init];
    cellObject.cellClass = cellClass;
    return cellObject;
}

@end
