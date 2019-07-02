//
//  HomeVC.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/6/19.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "HomeVC.h"

@interface HomeVC ()
@property (nonatomic, strong) UITextView *textView;

///dataArray
@property (atomic,strong) NSMutableArray *dataArray;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self testAtomic];
}

#pragma mark - configUI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    //textView
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderWidth = .5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:textView];
    self.textView = textView;
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).mas_offset(-100);
    }];
}

#pragma mark - actions

- (void)testAtomic {
    self.dataArray = [NSMutableArray array];
    
    dispatch_semaphore_t signal = dispatch_semaphore_create(0);
    for (int i = 0; i<10; i++) {
        ///并发队列 异步任务 具备开启多个线程能力
        dispatch_queue_t queue = dispatch_queue_create("queue",DISPATCH_QUEUE_CONCURRENT);
        ///写入任务
        dispatch_async(queue, ^{
            [self write:@(i)];
        });
        ///读取任务
        dispatch_async(queue, ^{
            [self read];
            dispatch_semaphore_signal(signal);
        });
        dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
    }

}

///读取操作
- (void) read {
    NSLog(@"%@",self.dataArray);
}
///写入操作
- (void) write:(id)obj {
    [self.dataArray addObject:obj];
}

@end
