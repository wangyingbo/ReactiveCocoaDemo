//
//  Promise+Extension.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/9/4.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "Promise.h"

NS_ASSUME_NONNULL_BEGIN

@interface Promise<__covariant ValueType> (Extension)
typedef id __nullable (^PromiseThenWorkBlock)(ValueType __nullable value);
typedef id __nullable (^PromiseDoWorkBlock)(void);

@property(class, nonatomic, readonly) dispatch_group_t dispatchGroup;

- (__kindof Promise<ValueType> *)then:(PromiseThenWorkBlock)block;

+ (instancetype)dowork:(PromiseDoWorkBlock)work;

@end

NS_ASSUME_NONNULL_END
