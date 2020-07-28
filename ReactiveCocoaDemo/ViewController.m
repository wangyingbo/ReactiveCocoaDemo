//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by fengbang on 2019/6/19.
//  Copyright © 2019 王颖博. All rights reserved.
//
//  demo讲解 https://github.com/shuaiwang007/RAC
//  ReactiveCocoa单向绑定与双向绑定 https://www.jianshu.com/p/63c713f28ad7
//  iOS 之ReactiveCocoa https://www.jianshu.com/p/060699578bea
//

#import "ViewController.h"
#import "HomeVC.h"

@interface ViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *button;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
    //[self rac_signal];
    
    //[self rac_subject];
    
    //[self rac_sequence];
    
    //[self rac_multicastConnection];
    
    //[self rac_command];
    
    //[self rac_macro];
    
    //[self rac_bind];
    
    //[self rac_filter];
    
    //[self rac_map];
    
    //[self rac_combine];
}

#pragma mark - configUI
- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    @onExit{
        /**原理：
         http://blog.sunnyxx.com/2014/09/15/objc-attribute-cleanup/
         https://www.jianshu.com/p/965f6f903114
        */
        NSLog(@"在方法执行的最后响应！");
    };
    
    //textView
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderWidth = .5;
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:textView];
    self.textView = textView;
    @weakify(self);
    [self.textView.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);[self class];
        
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view).mas_offset(-100);
        make.height.mas_greaterThanOrEqualTo(200);
    }];
    
    //label
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:11.];
    label.layer.borderWidth = .5;
    label.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:label];
    self.label = label;
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.textView);
        make.width.mas_lessThanOrEqualTo(self.view).mas_offset(-30.);
        make.bottom.mas_lessThanOrEqualTo(self.textView.mas_top).mas_offset(-20.);
    }];
    
    //button
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    self.button = button;
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        HomeVC *home = [[HomeVC alloc] init];
        [self.navigationController pushViewController:home animated:YES];
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).mas_offset(80);
        make.centerX.mas_equalTo(self.textView);
    }];
    
    NSLog(@"方法执行到最后了！");
}

#pragma mark - actions

/**
 测试RACSignal
 */
- (void)rac_signal {
    //1.创建信号 参见"RACSignal.h"和"RACSignal+Operations.h"类
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3.发送信号
        [subscriber sendNext:@"test"];
        // 4.取消信号，如果信号想要被取消，就必须返回一个RACDisposable
        // 信号什么时候被取消：1.自动取消，当一个信号的订阅者被销毁的时候机会自动取消订阅，2.手动取消，
        //block什么时候调用：一旦一个信号被取消订阅就会调用
        //block作用：当信号被取消时用于清空一些资源
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"RACSignal-取消订阅");
        }];
    }];
    
    // 2. 订阅信号
    //subscribeNext
    // 把nextBlock保存到订阅者里面
    // 只要订阅信号就会返回一个取消订阅信号的类
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        // block的调用时刻：只要信号内部发出数据就会调用这个block
        NSLog(@"RACSignal值======%@", x);
    }];
    // 取消订阅
    [disposable dispose];
}

/**
 测试RACSubject
 用RACSubject代替代理/通知
 RACSubject和RACReplaySubject的区别 RACSubject必须要先订阅信号之后才能发送信号， 而RACReplaySubject可以先发送信号后订阅. RACSubject 代码中体现为：先走TwoViewController的sendNext，后走ViewController的subscribeNext订阅 RACReplaySubject 代码中体现为：先走ViewController的subscribeNext订阅，后走TwoViewController的sendNext 可按实际情况各取所需。
 */
- (void)rac_subject {
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    //2.订阅信号
    [subject subscribeNext:^(id x) {
        // block:当有数据发出的时候就会调用
        // block:处理数据
        NSLog(@"RACSubject值：%@",x);
    }];
    //3.发送信号
    [subject sendNext:@"嘻嘻"];
    
    
    //RACReplaySubject
    //使用场景一:如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类。
    //使用场景二:可以设置capacity数量来限制缓存的value的数量,即只缓充最新的几个值。
    //大家好，我是土豪
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //张三关注了土豪
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"张三收到红包：%@",x]);
    }];
    //土豪发红包了
    [replaySubject sendNext:@"1个亿"];
    //李四看张三发财了也关注了土豪，并表示红包没抢到，要求重发
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",[NSString stringWithFormat:@"李四收到红包：%@",x]);
    }];
    //土豪表示，钱不是问题，不但重发，还把之前你没抢到的也发给你。
    [replaySubject sendNext:@"1毛钱"];
    
}

/**
 测试RACSequence
 
 1. RACTuple:元组类
 类似NSArray,用来包装值.
 2. RACSequence:集合类
 用于代替NSArray,NSDictionary,可以使用它来快速遍历数组和字典。
 3. RACScheduler
 针对RAC中的队列，GCD的封装。
 4. RACEvent
 把数据包装成信号事件(signalevent)。它主要通过RACSignal的-materialize来使用，然并卵
 RACUnit
 表⽰stream不包含有意义的值,也就是看到这个，可以直接理解为nil.
 
 快速高效的遍历数组和字典
 */
- (void)rac_sequence {
    NSArray *array = @[@"test",@"this",@(8),@{@"name":@"yingbo",@"id":@"110324054"}];
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"RACSequence：%@", x);
    } error:^(NSError *error) {
        NSLog(@"RACSequence：===error===");
    } completed:^{
        NSLog(@"RACSequence：ok---完毕");
    }];
    
    //也可以用宏定义
    NSDictionary *dict = @{@"key":@1, @"key2":@2};
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        FBLog(@"RACSequence：%@", x);
        NSString *key = x[0];
        NSString *value = x[1];
        // RACTupleUnpack宏：专门用来解析元组
        // RACTupleUnpack 等号右边：需要解析的元组 宏的参数，填解析的什么样数据
        // 元组里面有几个值，宏的参数就必须填几个
        RACTupleUnpack(NSString *k, NSString *v) = x;
        FBLog(@"RACSequence：%@ %@", key, value);
    } error:^(NSError *error) {
        FBLog(@"RACSequence：===error");
    } completed:^{
        FBLog(@"RACSequence：-----ok---完毕");
    }];
}

/**
 测试RACMulticastConnection
 多个订阅者，但是我们只想发送一个信号
 用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
 */
- (void)rac_multicastConnection {
    // 普通写法, 这样的缺点是：没订阅一次信号就得重新创建并发送请求，这样很不友好
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // didSubscribeblock中的代码都统称为副作用。
        // 发送请求---比如afn
        //FBLog(@"发送请求啦");
        // 发送信号
        [subscriber sendNext:@"测试文本"];
        return nil;
    }];
    [signal subscribeNext:^(id x) {
        //FBLog(@"RACMulticastConnection-1-%@", x);
    }];
    [signal subscribeNext:^(id x) {
        //FBLog(@"RACMulticastConnection-2-%@", x);
    }];
    [signal subscribeNext:^(id x) {
        //FBLog(@"RACMulticastConnection-3-%@", x);
    }];
    
    
    // 比较好的做法。 使用RACMulticastConnection，无论有多少个订阅者，无论订阅多少次，我只发送一个。
    // 1.发送请求，用一个信号内包装，不管有多少个订阅者，只想发一次请求
    RACSignal *rac_signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        FBLog(@"RACMulticastConnection-发送请求啦");
        // 发送信号
        [subscriber sendNext:@"测试文本"];
        return nil;
    }];
    //2. 创建连接类
    //创建： RACMulticastConnection通过RACSignal的-publish或者-muticast:方法创建
    RACMulticastConnection *connection = [rac_signal publish];
    [connection.signal subscribeNext:^(id x) {
        FBLog(@"RACMulticastConnection-%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        FBLog(@"RACMulticastConnection-%@", x);
    }];
    [connection.signal subscribeNext:^(id x) {
        FBLog(@"RACMulticastConnection-%@", x);
    }];
    //3. 连接。只有连接了才会把信号源变为热信号
    [connection connect];
    //注意：subsciber 会给所有的订阅者发送消息。（类似与RACSubject），虽然subScriber只被保存了一次
}

/**
 测试RACCommand
 RAC中用于处理事件的类，可以把事件如何处理，事件中的数据如何传递，包装到这个类中，他可以很方便的监控事件的执行过程，比如看事件有没有执行完毕
 RACCommand的实例能够决定是否可以被执行，这个特性能反应在UI上，而且它能确保在其不可用时不会被执行。通常，当一个命令可以执行时，会将它的属性allowsConcurrentExecution设置为它的默认值：NO，从而确保在这个命令已经正在执行的时候，不会同时再执行新的操作。命令执行的返回值是一个RACSignal，因此我们能对该返回值进行next:，completed或error:
 使用场景：监听按钮点击，网络请求
 */
- (void)rac_command {
    
    // 方式一：直接订阅执行命令返回的信号
    // 普通做法
    // RACCommand: 处理事件
    // 不能返回空的信号
    // 1.创建命令
    RACCommand *command1 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"1-执行命令产生的数据"];
            return nil;
        }];
    }];
    // 如何拿到执行命令中产生的数据呢？
    // 订阅命令内部的信号
    // 2.执行命令
    RACSignal *signal =[command1 execute:@1]; // 这里其实用到的是replaySubject 可以先发送命令再订阅
    // 在这里就可以订阅信号了
    [signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    // 方式二：
    // 1.创建命令
    RACCommand *command2 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //block调用，执行命令的时候就会调用
        NSLog(@"%@",input); // input 为执行命令传进来的参数
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"2-执行命令产生的数据"];
            return nil;
        }];
    }];
    // 订阅信号
    // 注意：这里必须是先订阅才能发送命令
    // executionSignals：信号源，信号中信号，signalofsignals:信号，发送数据就是信号
    [command2.executionSignals subscribeNext:^(RACSignal *x) {
        [x subscribeNext:^(id x) {
            NSLog(@"%@", x);
        }];
    }];
    
    // 2.执行命令
    [command2 execute:@2];
    
    
    // 方式三
    RACCommand *command3 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"3-发送信号"];
            return nil;
        }];
    }];
    // switchToLatest获取最新发送的信号，只能用于信号中信号。
    [command3.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 2.执行命令
    [command3 execute:@3];
    
    
    // switchToLatest--用于信号中信号
    // 创建信号中信号
    RACSubject *signalofsignals = [RACSubject subject];
    RACSubject *signalA = [RACSubject subject];
    // 订阅信号
//    [signalofsignals subscribeNext:^(RACSignal *x) {
//        [x subscribeNext:^(id x) {
//            NSLog(@"%@", x);
//        }];
//    }];
    // switchToLatest: 获取信号中信号发送的最新信号
    [signalofsignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"signalofsignals：%@", x);
    }];
    // 发送信号
    [signalofsignals sendNext:signalA];
    [signalA sendNext:@4];
    
    
    // 监听事件有没有完成
    //注意：当前命令内部发送数据完成，一定要主动发送完成
    // 1.创建命令
    RACCommand *command5 = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // block调用：执行命令的时候就会调用
        NSLog(@"%@", input);
        // 这里的返回值不允许为nil
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            // 发送数据
            [subscriber sendNext:@"5-执行命令产生的数据"];
            
            // *** 发送完成 **
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // 监听事件有没有完成
    [command5.executing subscribeNext:^(id x) {
        if ([x boolValue] == YES) { // 正在执行
            NSLog(@"5-当前正在执行%@", x);
        }else {
            // 执行完成/没有执行
            NSLog(@"5-执行完成/没有执行");
        }
    }];
    
    // 2.执行命令
    [command5 execute:@5];
}

/**
 常用的宏
 */
- (void)rac_macro {
    
    // RAC:把一个对象的某个属性绑定一个信号,只要发出信号,就会把信号的内容给对象的属性赋值
    // 给label的text属性绑定了文本框改变的信号
    RAC(self.label, text) = self.textView.rac_textSignal;
//    [self.textView.rac_textSignal subscribeNext:^(id x) {
//        self.label.text = x;
//    }];
    
    
    /**
     *  KVO
     *  RACObserveL:快速的监听某个对象的某个属性改变
     *  返回的是一个信号,对象的某个属性改变的信号
     */
    [RACObserve(self.label, text) subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    /**
     * RACTuple:元组类，类似NSArray,用来包装值.
     * 快速包装一个元组
     * 把包装的类型放在宏的参数里面,就会自动包装
     */
    RACTuple *tuple = RACTuplePack(@1,@2,@4);
    // 宏的参数类型要和元祖中元素类型一致， 右边为要解析的元祖。
    RACTupleUnpack_(NSNumber *num1, NSNumber *num2, NSNumber * num3) = tuple;// 4.元祖
    // 快速包装一个元组
    // 把包装的类型放在宏的参数里面,就会自动包装
    NSLog(@"%@ %@ %@", num1, num2, num3);
    
    
    /**
     1. rac_signalForSelector
     NSObject的分类，hook的方式 ，返回参数x是原方法传入参数的tuple
     */
    [[self rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    /**
     2. rac_valuesAndChangesForKeyPath
     KVO的RAC写法
     */
    [[self rac_valuesAndChangesForKeyPath:@"center" options:NSKeyValueObservingOptionNew observer:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    /**
     3. rac_signalForControlEvents
     把事件封装成singnal
     */
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    /**
     4. rac_addObserverForName
     RAC 的通知写法
     */
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    
    /**
     5. rac_textSignal
     监听文本框文字改变 只要文本框发出改变就会发出这个信号
     */
    [self.textView.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"文字改变了%@",x);
    }];
    
    
    /**
     6. rac_liftSelector:withSignalsFromArray:Signals:
     当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法
     */
    RACSignal *req1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        [subscriber sendNext:@"1"];
        return nil;
    }];
    RACSignal *req2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        [subscriber sendNext:@"2"];
        return nil;
    }];
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithParam1:param2:) withSignalsFromArray:@[req1,req2]];
    
    
    /**
     7. ignore ：
     忽略完某些值的信号
     */
    [[self.textView.rac_textSignal ignore:@"MOB"] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"ignore ->%@",x);
    }];
}

/**
 测试RAC-bind
 bind（绑定）的使用思想和Hook的一样---> 都是拦截API从而可以对数据进行操作，，而影响返回数据。
 发送信号的时候会来到xx行的block。在这个block里我们可以对数据进行一些操作，那么xx行打印的value和订阅绑定信号后的value就会变了。变成什么样随你喜欢喽
 */
- (void)rac_bind {
    // 1.创建信号
    RACSubject *subject = [RACSubject subject];
    // 2.绑定信号
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        // block调用时刻：只要绑定信号订阅就会调用。不做什么事情，
        return ^RACSignal *(id value, BOOL *stop){
            // 一般在这个block中做事 ，发数据的时候会来到这个block。
            // 只要源信号（subject）发送数据，就会调用block
            // block作用：处理源信号内容
            // value:源信号发送的内容，
            value = @3; // 如果在这里把value的值改了，那么订阅绑定信号的值即44行的x就变了
            NSLog(@"接受到源信号的内容：%@", value);
            //返回信号，不能为nil,如果非要返回空---则empty或 alloc init。
            return [RACSignal return:value]; // 把返回的值包装成信号
        };
    }];
    // 3.订阅绑定信号
    [bindSignal subscribeNext:^(id x) {
        NSLog(@"接收到绑定信号处理完的信号:%@", x);
    }];
    // 4.发送信号
    [subject sendNext:@"123"];
    
    //单向绑定
    RAC(self.label,text) = RACObserve(self.textView, text);
    //双向绑定
    RACChannelTo(self.label, text) = RACChannelTo(self.textView, text);
}

/**
 RAC-过滤
 有时候我们想要过滤一些信号，这时候我们便可以用RAC的过滤方法。过滤方法有好多种，如下代码，从不同情况下进行了分析。
 */
- (void)rac_filter {
    
    // 跳跃 ： 如下，skip传入2 跳过前面两个值
    // 实际用处： 在实际开发中比如 后台返回的数据前面几个没用，我们想跳跃过去，便可以用skip
    RACSubject *subjectSkip = [RACSubject subject];
    [[subjectSkip skip:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    [subjectSkip sendNext:@1];
    [subjectSkip sendNext:@2];
    [subjectSkip sendNext:@3];
    
    
    //distinctUntilChanged:-- 如果当前的值跟上一次的值一样，就不会被订阅到
    RACSubject *subjectDistinct = [RACSubject subject];
    [[subjectDistinct distinctUntilChanged] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subjectDistinct sendNext:@1];
    [subjectDistinct sendNext:@2];
    [subjectDistinct sendNext:@2]; // 不会被订阅
    
    
    // take:可以屏蔽一些值,去掉前面几个值---这里take为2 则只拿到前两个值
    RACSubject *subjectTake = [RACSubject subject];
    [[subjectTake take:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subjectTake sendNext:@1];
    [subjectTake sendNext:@2];
    [subjectTake sendNext:@3];
    
    
    //takeLast:和take的用法一样，不过他取的是最后的几个值，如下，则取的是最后两个值
    //注意点:takeLast 一定要调用sendCompleted，告诉他发送完成了，这样才能取到最后的几个值
    RACSubject *subjectTakeLast = [RACSubject subject];
    [[subjectTakeLast takeLast:2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subjectTakeLast sendNext:@1];
    [subjectTakeLast sendNext:@2];
    [subjectTakeLast sendNext:@3];
    [subjectTakeLast sendCompleted];
    
    
    // takeUntil:---给takeUntil传的是哪个信号，那么当这个信号发送信号或sendCompleted，就不能再接受源信号的内容了。
    RACSubject *subjectUntil = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    [[subjectUntil takeUntil:subject2] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subjectUntil sendNext:@1];
    [subjectUntil sendNext:@2];
    [subject2 sendNext:@3];  // 1
    //    [subject2 sendCompleted]; // 或2
    [subjectUntil sendNext:@4];
    
    
    // ignore: 忽略掉一些值
    //ignore:忽略一些值
    //ignoreValues:表示忽略所有的值
    // 1.创建信号
    RACSubject *subjectIgnore = [RACSubject subject];
    // 2.忽略一些值
    RACSignal *ignoreSignal = [subjectIgnore ignore:@2]; // ignoreValues:表示忽略所有的值
    // 3.订阅信号
    [ignoreSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 4.发送数据
    [subjectIgnore sendNext:@2];
    
    
    // 一般和文本框一起用，添加过滤条件
    // 只有当文本框的内容长度大于5，才获取文本框里的内容
    [[self.textView.rac_textSignal filter:^BOOL(id value) {
        // value 源信号的内容
        return [value length] > 5;
        // 返回值 就是过滤条件。只有满足这个条件才能获取到内容
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

/**
 RAC-映射
 RAC的映射在实际开发中有什么用呢？比如我们想要拦截服务器返回的数据，给数据拼接特定的东西或想对数据进行操作从而更改返回值，类似于这样的情况下，我们便可以考虑用RAC的映射，实例代码如下
 */
- (void)rac_map {
    // 创建信号
    RACSubject *subjectMap = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignalMap = [subjectMap map:^id(id value) {
        // 返回的类型就是你需要映射的值
        return [NSString stringWithFormat:@"ws:%@", value]; //这里将源信号发送的“123” 前面拼接了ws：
    }];
    // 订阅绑定信号
    [bindSignalMap subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号
    [subjectMap sendNext:@"123"];
    
    
    // 创建信号
    RACSubject *subjectFlatMap = [RACSubject subject];
    // 绑定信号
    RACSignal *bindSignalFlatMap = [subjectFlatMap flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        // block：只要源信号发送内容就会调用
        // value: 就是源信号发送的内容
        // 返回信号用来包装成修改内容的值
        return [RACSignal return:value];
    }];
    // flattenMap中返回的是什么信号，订阅的就是什么信号(那么，x的值等于value的值，如果我们操纵value的值那么x也会随之而变)
    // 订阅信号
    [bindSignalFlatMap subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送数据
    [subjectFlatMap sendNext:@"123"];
    
    
    // flattenMap 主要用于信号中的信号
    // 创建信号
    RACSubject *signalofSignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    // 订阅信号
    //方式1
    //    [signalofSignals subscribeNext:^(id x) {
    //
    //        [x subscribeNext:^(id x) {
    //            NSLog(@"%@", x);
    //        }];
    //    }];
    // 方式2
    //    [signalofSignals.switchToLatest  ];
    // 方式3
    //   RACSignal *bignSignal = [signalofSignals flattenMap:^RACStream *(id value) {
    //
    //        //value:就是源信号发送内容
    //        return value;
    //    }];
    //    [bignSignal subscribeNext:^(id x) {
    //        NSLog(@"%@", x);
    //    }];
    // 方式4--------也是开发中常用的
    [[signalofSignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        return [RACSignal return:value];
    }] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    // 发送信号
    [signalofSignals sendNext:signal];
    [signal sendNext:@"123"];
}

/**
 RAC-组合
 combine 发送的信号 在reduce block里面处理后发送出去。
 */
- (void)rac_combine {
    
    //当多个输入框都有值的时候按钮才可点击
    RACSignal *combinSignal = [RACSignal combineLatest:@[self.textView.rac_textSignal, self.textView.rac_textSignal] reduce:^id(NSString *account, NSString *pwd){
        //reduce里的参数一定要和combineLatest数组里的一一对应。
        // block: 只要源信号发送内容，就会调用，组合成一个新值。
        NSLog(@"%@ %@", account, pwd);
        return @(account.length && pwd.length);
    }];
    // 订阅信号
//    [combinSignal subscribeNext:^(id x) {
//        self.loginBtn.enabled = [x boolValue];
//    }];    // ----这样写有些麻烦，可以直接用RAC宏
    RAC(self.button, enabled) = combinSignal;
    
    
    //zipWith --- 把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元祖，才会触发压缩流的next事件。
    // 创建信号A
    RACSubject *signalA = [RACSubject subject];
    // 创建信号B
    RACSubject *signalB = [RACSubject subject];
    // 压缩成一个信号
    // **-zipWith-**: 当一个界面多个请求的时候，要等所有请求完成才更新UI
    // 等所有信号都发送内容的时候才会调用
    RACSignal *zipSignal = [signalA zipWith:signalB];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"%@", x); //所有的值都被包装成了元组
    }];
    
    // 发送信号 交互顺序，元组内元素的顺序不会变，跟发送的顺序无关，而是跟压缩的顺序有关[signalA zipWith:signalB]---先是A后是B
    [signalA sendNext:@1];
    [signalB sendNext:@2];
    
    
    // 任何一个信号请求完成都会被订阅到
    // merge --- 多个信号合并成一个信号，任何一个信号有新值就会调用
    // 创建信号C
    RACSubject *signalC = [RACSubject subject];
    // 创建信号D
    RACSubject *signalD = [RACSubject subject];
    //组合信号
    RACSignal *mergeSignal = [signalC merge:signalD];
    // 订阅信号
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    // 发送信号---交换位置则数据结果顺序也会交换
    [signalD sendNext:@"下部分"];
    [signalC sendNext:@"上部分"];
    
    
    // then --- 使用需求：有两部分数据：想让上部分先进行网络请求但是过滤掉数据，然后进行下部分的，拿到下部分数据
    // 创建信号E
    RACSignal *signalE = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    // 创建信号F
    RACSignal *signalsF = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // 创建组合信号
    // then;忽略掉第一个信号的所有值
    RACSignal *thenSignal = [signalE then:^RACSignal *{
        // 返回的信号就是要组合的信号
        return signalsF;
    }];
    // 订阅信号
    [thenSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    
    // concat----- 使用需求：有两部分数据：想让上部分先执行，完了之后再让下部分执行（都可获取值）
    // 创建信号G
    RACSignal *signalG = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"----发送上部分请求---afn");
        
        [subscriber sendNext:@"上部分数据"];
        [subscriber sendCompleted]; // 必须要调用sendCompleted方法！
        return nil;
    }];
    // 创建信号H，
    RACSignal *signalsH = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求
        //        NSLog(@"--发送下部分请求--afn");
        [subscriber sendNext:@"下部分数据"];
        return nil;
    }];
    // concat:按顺序去链接
    //**-注意-**：concat，第一个信号必须要调用sendCompleted
    // 创建组合信号
    RACSignal *concatSignal = [signalG concat:signalsH];
    // 订阅组合信号
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}


@end
