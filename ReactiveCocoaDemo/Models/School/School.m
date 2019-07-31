//
//  School.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/31.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "School.h"

@implementation School

- (void)addTask:(void (^)(id<NSCoding> _Nullable))handler {
    !handler?:handler((id<NSCoding>)self);
}

- (id<NSCoding>)type {
    return (id<NSCoding>)self;
}

- (School *)with {
    return self;
}

@end
