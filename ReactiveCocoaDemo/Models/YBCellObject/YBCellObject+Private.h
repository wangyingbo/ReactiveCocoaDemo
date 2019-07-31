//
//  YBCellObject+Private.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/2.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "YBCellObject.h"

NS_ASSUME_NONNULL_BEGIN


@interface YBCellObject ()
/**
 不是类YBCellObject的category，是YBCellObject的匿名扩展extension
 是对CellObjectDelegate协议的实现，通过getter方法实现
 */
@property (nonatomic, assign) Class cellClass;
@end

NS_ASSUME_NONNULL_END
