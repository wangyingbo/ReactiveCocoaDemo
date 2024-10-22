//
//  CustomView.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/2.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface CustomView<__covariant ValueType> : UIView

typedef void(^hanlder)(ValueType obj);

- (void)addTask:(void(^)(ValueType _Nullable type))handler;

- (CustomView<__kindof UIView *> *)with;

- (void)next:(hanlder)hanlder;

@end

NS_ASSUME_NONNULL_END
