//
//  SLCursorCodeView.m
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/8.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import "SLCursorCodeView.h"

@interface SLCursorCodeView()

/**
 验证码个数
 */
@property (nonatomic, assign) NSInteger itemCount;

/**
 验证码间距
 */
@property (nonatomic, assign) CGFloat itemMargin;

/**
 验证码输入框
 */
@property (nonatomic, weak) UITextField *textField;

/**
 小技巧：通过textField上层覆盖一个maskView，可以去掉textField的长按事件
 */
@property (nonatomic, weak) UIButton *maskView;

/**
 显示验证码的label
 */
@property (nonatomic, strong) NSMutableArray<SLCursorLabel *> *labels;

/**
 下划线
 */
@property (nonatomic, strong) NSMutableArray<UIView *> *lines;

/**
 当前显示label
 */
@property (nonatomic, weak) SLCursorLabel *currentLabel;


@end

@implementation SLCursorCodeView


- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin {
    if (self = [super init]) {
        self.itemCount = count;
        self.itemMargin = margin;
        
        [self configureTextField];
    }
    return self;
}


- (void)configureTextField {
    self.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:textField];
    
    UIButton *maskView = [[UIButton alloc] init];
    self.maskView = maskView;
    maskView.backgroundColor = [UIColor whiteColor];
    [maskView addTarget:self action:@selector(clickMaskView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:maskView];
    
    for (NSInteger i = 0; i < self.itemCount; i++) {
        SLCursorLabel *label = [[SLCursorLabel alloc] init];
        label.textColor = [UIColor darkTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.6];
        [self.labels addObject:label];
        [self addSubview:label];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor purpleColor];
        [self.lines addObject:line];
        [self addSubview:line];
    }
}


- (void)textFieldEditingChanged:(UITextField *)textField {
    if (textField.text.length > self.itemCount) {
        textField.text = [textField.text substringToIndex:self.itemCount];
    }
    
    for (NSInteger i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (i < textField.text.length) {
            label.text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        } else {
            label.text = nil;
        }
    }
    
    // setup cursor
    [self setupCursor];
    
    // complete
    if (textField.text.length >= self.itemCount) {
        [textField resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(cursorCodeViewDidInputCompleted:)]) {
            [_delegate cursorCodeViewDidInputCompleted:self];
        }
    }
}


- (void)clickMaskView:(UIButton *)maskView {
    [self.textField becomeFirstResponder];
    // 开始输入时就要有光标
    [self setupCursor];
}


- (void)setupCursor {
    [self.currentLabel stopAnimating];
    
    NSInteger index = self.code.length;
    if (index < 0) {
        index = 0;
    }
    
    if (index >= self.labels.count) {
        index = self.labels.count - 1;
    }
    
    SLCursorLabel *label = self.labels[index];
    [label startAnimating];
    self.currentLabel = label;
}


#pragma mark - override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount) {
        return;
    }
    
    CGFloat temp = self.bounds.size.width - self.itemMargin * (self.itemCount - 1);
    CGFloat w = temp / (self.itemCount * 1.0);
    CGFloat x = 0;
    for (NSInteger i = 0; i < self.labels.count; i++) {
        x = i * (w + self.itemMargin);
        UILabel *label = self.labels[i];
        label.frame = CGRectMake(x, 0, w, self.bounds.size.height);
        
        UIView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1.0, w, 1.0);
    }
    
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
}


- (BOOL)endEditing:(BOOL)force {
    [self.textField endEditing:force];
    // 结束编辑时要将光标闪烁停止
    [self.currentLabel stopAnimating];
    return [super endEditing:force];
}


#pragma mark - getter

- (NSString *)code {
    return self.textField.text;
}

- (NSMutableArray<SLCursorLabel *> *)labels {
    if (_labels) {
        return _labels;
    }
    _labels = [NSMutableArray arrayWithCapacity:self.itemCount];
    return _labels;
}

- (NSMutableArray<UIView *> *)lines {
    if (_lines) {
        return _lines;
    }
    _lines = [NSMutableArray arrayWithCapacity:self.itemCount];
    return _lines;
}


@end


// ------------------------------------------------------------------------
// -----------------------------SLCursorLabel------------------------------
// ------------------------------------------------------------------------

@interface SLCursorLabel()

@property (nonatomic, weak) UIView *cursorView;

@end

@implementation SLCursorLabel

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}


#pragma mark - setupView

- (void)setupView {
    UIView *cursorView = [[UIView alloc] init];
    self.cursorView = cursorView;
    cursorView.backgroundColor = self.textColor;
    cursorView.alpha = 0;
    [self addSubview:cursorView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 光标上下间距
    const CGFloat margin = 10.0;
    self.cursorView.bounds = CGRectMake(0, 0, 1.5, self.bounds.size.height - margin * 2.0);
    self.cursorView.center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
}


- (void)startAnimating {
    if (self.text.length > 0) {
        return;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.7;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(0.02);
    animation.toValue = @(1.0);
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.cursorView.layer addAnimation:animation forKey:@"opacity"];
}


- (void)stopAnimating {
    [self.cursorView.layer removeAnimationForKey:@"opacity"];
}

@end

