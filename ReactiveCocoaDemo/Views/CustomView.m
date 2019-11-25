//
//  CustomView.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/2.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (void)dealloc {
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
}

- (CustomView<UIView *> *)with {
    return self;
}

- (void)addTask:(void (^)(id _Nullable))handler {
    NSDictionary *dic = @{};
    !handler?:handler(dic);
}

- (void)next:(hanlder)hanlder {
    !hanlder?:hanlder(self);
}

@end
