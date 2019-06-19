//
//  Header.h
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/6/19.
//  Copyright © 2019 王颖博. All rights reserved.
//

#ifndef Header_h
#define Header_h



/**用printf定义log*/
#ifdef DEBUG
#define FBLog(...) printf("打印：%s第%d行\n%s\n",__func__,__LINE__,[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define FBLog(...)
#endif



#endif /* Header_h */
