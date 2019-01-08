//
//  SLBasicCodeView.h
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/4.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLBasicCodeView;

@protocol SLBasicCodeViewDelegate <NSObject>

@optional

/**
 验证码输入完成代理回调

 @param basicCodeView 验证码输入View
 */
- (void)basicCodeViewDidInputCompleted:(SLBasicCodeView *)basicCodeView;

@end


NS_ASSUME_NONNULL_BEGIN

/**
 基础版 - 下划线
 */
@interface SLBasicCodeView : UIView

/**
 当前已输入的内容
 */
@property (nonatomic, copy, readonly) NSString *code;

/**
 代理
 */
@property (nonatomic, weak) id<SLBasicCodeViewDelegate> delegate;


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

NS_ASSUME_NONNULL_END
