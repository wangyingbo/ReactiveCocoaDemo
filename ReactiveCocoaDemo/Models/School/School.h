//
//  School.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/31.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface School<__covariant T:id<NSCoding>> : NSObject

@property (nonatomic, copy) NSString *schoolName;

/**添加任务*/
- (void)addTask:(void(^)(T __nullable x))handler;

/**返回自身*/
- (T)type;

/**返回指定类型*/
- (School<__kindof NSString *> *)with;

@end

           
NS_ASSUME_NONNULL_END
