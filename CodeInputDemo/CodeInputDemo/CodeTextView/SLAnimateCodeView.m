//
//  SLAnimateCodeView.m
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/8.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import "SLAnimateCodeView.h"

@interface SLAnimateCodeView()

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
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;

/**
 下划线
 */
@property (nonatomic, strong) NSMutableArray<SLAnimateLineView *> *lines;

/**
 临时保存上次输入的内容（用于判断当前是删除还是输入）
 */
@property (nonatomic, copy) NSString *tempCode;


@end

@implementation SLAnimateCodeView

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
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor purpleColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.6];
        [self.labels addObject:label];
        [self addSubview:label];
        
        SLAnimateLineView *line = [[SLAnimateLineView alloc] init];
        line.backgroundColor = [UIColor redColor];
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
            if (i < self.lines.count) {
                self.lines[i].backgroundColor = [UIColor greenColor];
            }
        } else {
            label.text = nil;
            if (i < self.lines.count) {
                self.lines[i].backgroundColor = [UIColor redColor];
            }
        }
    }
    
    // 如果当前输入框内容长度比上一次输入的内容长度要长，则说明当前正在输入，需要展示动画
    // 否则表示删除，删除时不显示动画。
    if (self.tempCode.length < textField.text.length) {
        if (textField.text == nil || textField.text.length <= 0) {
            [self.lines.firstObject lineAnimation];
        } else if (textField.text.length >= self.itemCount) {
            [self.lines.lastObject lineAnimation];
            [self animation:self.labels.lastObject];
        } else {
            [self.lines[textField.text.length - 1] lineAnimation];
            [self animation:self.labels[textField.text.length - 1]];
        }
    }
    
    // 记录当前输入内容
    self.tempCode = textField.text;
    
    // complete
    if (textField.text.length >= self.itemCount) {
        [textField resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(animateCodeViewDidInputCompleted:)]) {
            [_delegate animateCodeViewDidInputCompleted:self];
        }
    }
}


- (void)clickMaskView:(UIButton *)maskView {
    [self.textField becomeFirstResponder];
}


- (void)animation:(UILabel *)label {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.2;
    animation.repeatCount = 1;
    animation.fromValue = @(0.01);
    animation.toValue = @(1.0);
    [label.layer addAnimation:animation forKey:@"zoom"];
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
        
        SLAnimateLineView *line = self.lines[i];
        line.frame = CGRectMake(x, self.bounds.size.height - 1.0, w, 1.0);
    }
    
    self.textField.frame = self.bounds;
    self.maskView.frame = self.bounds;
}


- (BOOL)endEditing:(BOOL)force {
    [self.textField endEditing:force];
    return [super endEditing:force];
}



#pragma mark - getter

- (NSString *)code {
    return self.textField.text;
}

- (NSMutableArray<UILabel *> *)labels {
    if (_labels) {
        return _labels;
    }
    _labels = [NSMutableArray arrayWithCapacity:self.itemCount];
    return _labels;
}

- (NSMutableArray<SLAnimateLineView *> *)lines {
    if (_lines) {
        return _lines;
    }
    _lines = [NSMutableArray arrayWithCapacity:self.itemCount];
    return _lines;
}

@end



// ------------------------------------------------------------------------
// -----------------------------SLAnimateLineView--------------------------
// ------------------------------------------------------------------------

@interface SLAnimateLineView()

@property (nonatomic, weak) UIView *colorView;

@end


@implementation SLAnimateLineView

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
    UIView *colorView = [[UIView alloc] init];
    self.colorView = colorView;
    [self addSubview:colorView];
}


- (void)lineAnimation {
    [self.colorView.layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animation.duration = 0.18;
    animation.repeatCount = 1.0;
    animation.fromValue = @(1.0);
    animation.toValue = @(0.01);
    animation.autoreverses = YES;
    
    [self.colorView.layer addAnimation:animation forKey:@"zoom.scale.x"];
}


#pragma mark - override

- (void)layoutSubviews {
    [super layoutSubviews];
    self.colorView.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
    self.colorView.backgroundColor = backgroundColor;
}

@end
