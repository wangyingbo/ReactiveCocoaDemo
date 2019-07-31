//
//  Grade.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/7/31.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "Grade.h"

@implementation Grade

- (void)fool {
    
    if (!method1()) { return; }
    
    if (!method2()) { return; }
    
    if (!method3()) { return; }
    
    if (!method4()) { return; }
    
    //提交操作
    printf("提交数据");
}

bool method1() {
    return NO;
}

bool method2() {
    return YES;
}

bool method3() {
    return NO;
}

bool method4() {
    return YES;
}


@end
