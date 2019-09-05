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
#define Lock() dispatch_semaphore_wait(self->_semaphore, DISPATCH_TIME_FOREVER)
#define Unlock() dispatch_semaphore_signal(self->_semaphore)

@interface Promise ()
@property (nonatomic, copy) PromiseThenWorkBlock thenBlock;
@property (nonatomic, strong) id returnThenValue;
@property (nonatomic, copy) void(^observerBlock)(void);
@property (nonatomic, strong) NSObject *tool;
@end

@implementation Promise {
    dispatch_semaphore_t _semaphore;
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

- (void)setReturnThenValue:(id)returnThenValue {
    @synchronized (self) {
        _returnThenValue = returnThenValue;
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
    if (self.thenBlock) {
        Promise *promise = [[Promise alloc] initPending];
        __weak typeof(self)weakSelf = self;
        dispatch_group_async(Promise.dispatchGroup, Promise.defaultDispatchQueue, ^{
            __strong typeof(weakSelf)self = weakSelf;
            id lastReturnThenValue = _returnThenValue;
            promise.thenBlock = block;
            id returnThenValue = promise.thenBlock(lastReturnThenValue);
            if (returnThenValue) {
                self.returnThenValue = returnThenValue;
                dispatch_group_leave(Promise.dispatchGroup);
            }
        });
        return promise;
        
    }else {
        self.thenBlock = block;
        return self;
    }
}

+ (instancetype)dowork:(PromiseDoWorkBlock)work {
    Promise *promise = [[Promise alloc] initPending];
    __block id returnDoValue = nil;
    dispatch_group_async(Promise.dispatchGroup, Promise.defaultDispatchQueue, ^{
        returnDoValue = !work?nil:work();
        id returnThenValue = !promise.thenBlock?returnDoValue:promise.thenBlock(returnDoValue);
        promise.returnThenValue = returnThenValue;
        dispatch_group_leave(Promise.dispatchGroup);
    });
    
    return promise;
}

@end
