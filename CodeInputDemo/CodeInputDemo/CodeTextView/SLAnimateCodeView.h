//
//  SLAnimateCodeView.h
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/8.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SLAnimateCodeView;

@protocol SLAnimateCodeViewDelegate <NSObject>

@optional

/**
 验证码输入完成代理回调
 
 @param animateCodeView 验证码输入View
 */
- (void)animateCodeViewDidInputCompleted:(SLAnimateCodeView *)animateCodeView;

@end


/**
 完善版 - 动画 - 下划线
 */
@interface SLAnimateCodeView : UIView

/**
 当前已输入的内容
 */
@property (nonatomic, copy, readonly) NSString *code;

/**
 代理
 */
@property (nonatomic, weak) id<SLAnimateCodeViewDelegate> delegate;

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
// -----------------------------SLAnimateLineView--------------------------
// ------------------------------------------------------------------------

@interface SLAnimateLineView : UIView

- (void)lineAnimation;

@end


NS_ASSUME_NONNULL_END
