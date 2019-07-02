//
//  HomeVC.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/6/19.
//  Copyright © 2019 王颖博. All rights reserved.
//

#import "HomeVC.h"
#import "CustomView.h"
#import "YBCellObject.h"

@interface HomeVC ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) CustomView *myView;

/**dataArray-用信号量锁线程的话，没必要用atomic*/
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    [self testAtomic];
    
    [self configTimer];
}

- (void)dealloc {
    NSLog(@"%@销毁了",NSStringFromClass([self class]));
    [self.timer invalidate];
    NSLog(@"定时器销毁了");
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
        make.height.mas_equalTo(100.);
    }];
    
    CustomView *myView = [[CustomView alloc] init];
    myView.backgroundColor = [UIColor redColor];
    [self.view addSubview:myView];
    self.myView = myView;
    [self.myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textView);
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(65.);
        make.width.height.mas_equalTo(50.);
    }];
    
    YBCellObject *cellObj = [YBCellObject objectWithCellClass:[CustomView class]];
    if ([cellObj respondsToSelector:@selector(cellClass)]) {
        //NSLog(@"对类%@的扩展extension，不是类的category，通过getter方法来实现协议里的方法",NSStringFromClass([YBCellObject class]));
        //NSLog(@"类名：%@",NSStringFromClass(cellObj.cellClass));
    }
}

#pragma mark - actions

- (void)testAtomic {
    self.dataArray = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_semaphore_t signal = dispatch_semaphore_create(0);
        for (int i = 0; i<10; i++) {
            ///并发队列 异步任务 具备开启多个线程能力
            dispatch_queue_t queue = dispatch_queue_create("queue",DISPATCH_QUEUE_CONCURRENT);
            ///写入任务
            dispatch_async(queue, ^{
                NSLog(@"------task------%@", [NSThread currentThread]);
                [self write:@(i)];
            });
            ///读取任务
            dispatch_async(queue, ^{
                [self read];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), queue, ^{
                    //NSLog(@"------task------%@", [NSThread currentThread]);
                    dispatch_semaphore_signal(signal);
                });
            });
            dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
        }
        
    });

}

///读取操作
- (void) read {
    NSLog(@"%@",self.dataArray);
}
///写入操作
- (void) write:(id)obj {
    [self.dataArray addObject:obj];
}

- (void)configTimer {
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            NSLog(@"定时器走：%f",[[NSDate date] timeIntervalSince1970]);
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

@end
