//
//  SLBasicCodeView.m
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/4.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import "SLBasicCodeView.h"

@interface SLBasicCodeView()

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
@property (nonatomic, strong) NSMutableArray<UIView *> *lines;

@end

@implementation SLBasicCodeView

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
        label.textColor = [UIColor darkTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:41.5];
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
    
    // complete
    if (textField.text.length >= self.itemCount) {
        [textField resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(basicCodeViewDidInputCompleted:)]) {
            [_delegate basicCodeViewDidInputCompleted:self];
        }
    }
}

- (void)clickMaskView:(UIButton *)maskView {
    [self.textField becomeFirstResponder];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.labels.count != self.itemCount || self.lines.count != self.itemCount) {
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

- (NSMutableArray<UIView *> *)lines {
    if (_lines) {
        return _lines;
    }
    _lines = [NSMutableArray arrayWithCapacity:self.itemCount];
    return _lines;
}

@end
