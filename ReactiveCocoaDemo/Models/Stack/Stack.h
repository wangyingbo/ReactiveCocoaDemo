//
//  Stack.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/31.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/**
 只接受 NSNumber * 的泛型
 @interface Stack<ObjectType: NSNumber *> : NSObject
 只接受满足 NSCopying 协议的泛型
 @interface Stack<ObjectType: id<NSCopying>> : NSObject
 协变
 @interface Stack<__covariant ObjectType> : NSObject
 逆变
 @interface Stack<__contravariant ObjectType> : NSObject
 */


@interface Stack<__covariant ObjectType:id<NSCoding> > : NSObject

typedef void(^StackBlock)(ObjectType object);

/**入栈*/
- (void)pushObject:(ObjectType)object;

/**出栈*/
- (ObjectType)popObject;

/**获取栈内所有对象*/
@property (nonatomic, readonly) NSArray<ObjectType> *allObjects;

/**是否为空*/
- (BOOL)isEmpty;

/**栈的长度*/
- (NSInteger)stackLength;

/**清空*/
-(void)removeAllObjects;

/**返回栈顶元素*/
-(ObjectType)topObject;

/**从栈底开始遍历*/
-(void)enumerateObjectsFromBottom:(StackBlock)block;

/**从顶部开始遍历*/
-(void)enumerateObjectsFromTop:(StackBlock)block;

/**所有元素出栈，一边出栈一边返回元素*/
-(void)enumerateObjectsPopStack:(StackBlock)block;

@end

NS_ASSUME_NONNULL_END
