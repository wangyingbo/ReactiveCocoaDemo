//
//  YBCellObject.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/2.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CellObjectDelegate <NSObject>
@required
- (Class)cellClass;
@end

@interface YBCellObject : NSObject<CellObjectDelegate>

+ (instancetype)objectWithCellClass:(Class)cellClass;

@end

NS_ASSUME_NONNULL_END
