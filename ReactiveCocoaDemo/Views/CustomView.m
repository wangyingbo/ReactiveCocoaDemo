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

- (void)addTask:(void (^)(id _Nullable))handler {
    !handler?:handler(self);
}

@end
