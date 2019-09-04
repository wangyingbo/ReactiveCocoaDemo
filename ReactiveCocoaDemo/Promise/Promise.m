//
//  Promise.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/9/4.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "Promise.h"
#import "Promise+Extension.h"

static dispatch_queue_t kPromiseDefaultDispatchQueue;

@interface Promise ()
@property (nonatomic, copy) PromiseThenWorkBlock thenBlock;

@end

@implementation Promise {
}

+ (void)initialize {
    if (self == [Promise class]) {
        kPromiseDefaultDispatchQueue = dispatch_get_main_queue();
    }
}

+ (dispatch_group_t)dispatchGroup {
    static dispatch_group_t gDispatchGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDispatchGroup = dispatch_group_create();
    });
    return gDispatchGroup;
}

+ (dispatch_queue_t)defaultDispatchQueue {
    @synchronized(self) {
        return kPromiseDefaultDispatchQueue;
    }
}

+ (void)setDefaultDispatchQueue:(dispatch_queue_t)queue {
    NSParameterAssert(queue);
    
    @synchronized(self) {
        kPromiseDefaultDispatchQueue = queue;
    }
}

- (instancetype)initPending {
    self = [super init];
    if (self) {
        dispatch_group_enter(Promise.dispatchGroup);
    }
    return self;
}

#pragma mark - extension

- (Promise *)then:(PromiseThenWorkBlock)block {
    Promise *promise = [[Promise alloc] initPending];
    promise.thenBlock = block;
    return promise;
}

+ (instancetype)dowork:(PromiseDoWorkBlock)work {
    Promise *promise = [[Promise alloc] initPending];
    __block id returnDoValue = nil;
    dispatch_group_async(Promise.dispatchGroup, Promise.defaultDispatchQueue, ^{
        returnDoValue = !work?nil:work();
        dispatch_group_leave(Promise.dispatchGroup);
    });
    dispatch_group_notify(Promise.dispatchGroup, Promise.defaultDispatchQueue, ^{
        id returnThenValue = !promise.thenBlock?nil:promise.thenBlock(returnDoValue);
    });
    
    return promise;
}

@end
