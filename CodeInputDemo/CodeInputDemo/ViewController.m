//
//  ViewController.m
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/4.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import "ViewController.h"

#import "SLBasicCodeView.h"
#import "SLBlockCodeView.h"
#import "SLAnimateCodeView.h"
#import "SLCursorCodeView.h"

@interface ViewController ()<SLBasicCodeViewDelegate, SLBlockCodeViewDelegate, SLAnimateCodeViewDelegate, SLCursorCodeViewDelegate>

@property (nonatomic, weak) SLBasicCodeView *basicCodeView;
@property (nonatomic, weak) SLBlockCodeView *blockCodeView;
@property (nonatomic, weak) SLAnimateCodeView *animateCodeView;
@property (nonatomic, weak) SLCursorCodeView *cursorCodeView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    // scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scrollView.contentSize = CGSizeMake(SCREEN_W, SCREEN_H * 1.5);
    scrollView.layer.borderWidth = 5.5;
    scrollView.layer.borderColor = SLRandomColor.CGColor;
    [self.view addSubview:scrollView];
    
    // title lable
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN, 25, SCREEN_W - 40, 20)];
    titleLabel.text = @"😘页面可滑动，防止键盘挡住效果😘";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:titleLabel];
    
    // basic label
    UILabel *basicLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(titleLabel.frame) + DEFAULT_MARGIN, SCREEN_W - DEFAULT_MARGIN * 2, 20)];
    basicLabel.text = @"基本实现原理 - 下划线";
    basicLabel.textColor = [UIColor orangeColor];
    basicLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:basicLabel];
    
    // basic code view
    SLBasicCodeView *basicCodeView = [[SLBasicCodeView alloc] initWithCount:6 margin:20.0];
    self.basicCodeView = basicCodeView;
    basicCodeView.frame = CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(basicLabel.frame) + 10, SCREEN_W - DEFAULT_MARGIN * 2, 50);
    basicCodeView.delegate = self;
    [scrollView addSubview:basicCodeView];
    
    
    // block label
    UILabel *blockLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(basicCodeView.frame) + DEFAULT_MARGIN, SCREEN_W - DEFAULT_MARGIN * 2, 20)];
    blockLabel.text = @"基本实现原理 - 方块";
    blockLabel.textColor = [UIColor orangeColor];
    blockLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:blockLabel];
    
    // block code view
    SLBlockCodeView *blockCodeView = [[SLBlockCodeView alloc] initWithCount:6 margin:20.0];
    self.blockCodeView = blockCodeView;
    blockCodeView.frame = CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(blockLabel.frame) + 10, SCREEN_W - DEFAULT_MARGIN * 2, 50);
    blockCodeView.delegate = self;
    [scrollView addSubview:blockCodeView];
    
    // complete animation label
    UILabel *animateLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(blockCodeView.frame) + DEFAULT_MARGIN, SCREEN_W - DEFAULT_MARGIN * 2, 20)];
    animateLabel.text = @"完善版 - 加入动画 - 下划线";
    animateLabel.textColor = [UIColor orangeColor];
    animateLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:animateLabel];
    
    // complete animation code view
    SLAnimateCodeView *animateCodeView = [[SLAnimateCodeView alloc] initWithCount:6 margin:20.0];
    self.animateCodeView = animateCodeView;
    animateCodeView.frame = CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(animateLabel.frame) + 10, SCREEN_W - DEFAULT_MARGIN * 2, 50);
    animateCodeView.delegate = self;
    [scrollView addSubview:animateCodeView];
    
    // cursor label
    UILabel *cursorLabel = [[UILabel alloc] initWithFrame:CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(animateCodeView.frame) + DEFAULT_MARGIN, SCREEN_W - DEFAULT_MARGIN * 2, 20)];
    cursorLabel.text = @"基础版 - 动画 - 带光标";
    cursorLabel.textColor = [UIColor orangeColor];
    cursorLabel.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:cursorLabel];
    
    // cursor code view
    SLCursorCodeView *cursorCodeView = [[SLCursorCodeView alloc] initWithCount:6 margin:20.0];
    self.cursorCodeView = cursorCodeView;
    cursorCodeView.frame = CGRectMake(DEFAULT_MARGIN, CGRectGetMaxY(cursorLabel.frame) + 10, SCREEN_W - DEFAULT_MARGIN * 2, 50);
    cursorCodeView.delegate = self;
    [scrollView addSubview:cursorCodeView];
    
    
    // tap gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [scrollView addGestureRecognizer:tap];
    
}


- (void)onTap:(UITapGestureRecognizer *)tap {
    NSLog(@"tap: - %@", tap);
    
    [self.basicCodeView endEditing:YES];
    [self.blockCodeView endEditing:YES];
    [self.animateCodeView endEditing:YES];
    [self.cursorCodeView endEditing:YES];
}



#pragma mark - SLBasicCodeViewDelegate

- (void)basicCodeViewDidInputCompleted:(SLBasicCodeView *)basicCodeView {
    NSLog(@"basic code: - %@", basicCodeView.code);
}

#pragma mark - SLBlockCodeViewDelegate

- (void)blockCodeViewDidInputCompleted:(SLBlockCodeView *)blockCodeView {
    NSLog(@"block code: - %@", blockCodeView.code);
}

#pragma mark - SLAnimateCodeViewDelegate

- (void)animateCodeViewDidInputCompleted:(SLAnimateCodeView *)animateCodeView {
    NSLog(@"animate code: - %@", animateCodeView.code);
}

#pragma mark - SLCursorCodeViewDelegate

- (void)cursorCodeViewDidInputCompleted:(SLCursorCodeView *)cursorCodeView {
    NSLog(@"cursor code: - %@", cursorCodeView.code);
}

@end
