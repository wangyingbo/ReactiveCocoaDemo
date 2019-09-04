//
//  Promise.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/9/4.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Promise<__covariant ValueType> : NSObject

@property(class) dispatch_queue_t defaultDispatchQueue;

@end

NS_ASSUME_NONNULL_END
