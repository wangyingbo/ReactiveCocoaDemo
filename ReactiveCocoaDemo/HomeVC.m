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
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
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

@end
