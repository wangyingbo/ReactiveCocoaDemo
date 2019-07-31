//
//  Stack.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/31.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "Stack.h"

@interface Stack ()
@property (nonatomic, strong) NSMutableArray *stackArray;
@end

@implementation Stack

- (NSMutableArray *)stackArray {
    if (!_stackArray) {
        NSMutableArray *arr = [NSMutableArray array];
        _stackArray = arr;
    }
    return _stackArray;
}

- (void)pushObject:(id<NSCoding>)object {
    [self.stackArray addObject:object];
}

- (id<NSCoding>)popObject {
    if (self.isEmpty) {
        return nil;
    }
    id object = [self.stackArray lastObject];
    [self.stackArray removeLastObject];
    return object;
}

- (NSArray *)allObjects {
    return self.stackArray.copy;
}

- (BOOL)isEmpty {
    return !self.stackArray.count;
}

- (NSInteger)stackLength {
    return self.stackArray.count;
}

- (void)removeAllObjects {
    [self.stackArray removeAllObjects];
}

- (id<NSCoding>)topObject {
    if (self.isEmpty) {
        return nil;
    }
    return self.stackArray.lastObject;
}

- (void)enumerateObjectsFromBottom:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

- (void)enumerateObjectsFromTop:(StackBlock)block {
    [self.stackArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        block ? block(obj) : nil;
    }];
}

- (void)enumerateObjectsPopStack:(StackBlock)block {
    __weak typeof(self) weakSelf = self;
    NSUInteger count = self.stackArray.count;
    for (NSUInteger i = count; i > 0; i --) {
        if (block) {
            block(weakSelf.stackArray.lastObject);
            [self.stackArray removeLastObject];
        }
    }
}

@end
