//
//  SLCursorCodeView.h
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/8.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SLCursorCodeView;

@protocol SLCursorCodeViewDelegate <NSObject>

@optional

/**
 验证码输入完成代理回调
 
 @param cursorCodeView 验证码输入View
 */
- (void)cursorCodeViewDidInputCompleted:(SLCursorCodeView *)cursorCodeView;

@end

/**
 基础版 - 光标 - 下划线
 */
@interface SLCursorCodeView : UIView

/**
 当前已输入的内容
 */
@property (nonatomic, copy, readonly) NSString *code;

/**
 代理
 */
@property (nonatomic, weak) id<SLCursorCodeViewDelegate> delegate;

/**
 初始化验证码输入View
 
 @param count 验证码个数
 @param margin 间距
 @return 验证码view
 */
- (instancetype)initWithCount:(NSInteger)count margin:(CGFloat)margin;


/**
 禁用系统初始化方法
 
 @return view
 */
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

@end


// ------------------------------------------------------------------------
// -----------------------------SLCursorLabel------------------------------
// ------------------------------------------------------------------------

@interface SLCursorLabel : UILabel

/**
 开始动画
 */
- (void)startAnimating;

/**
 结束动画
 */
- (void)stopAnimating;

@end


NS_ASSUME_NONNULL_END
