//
//  ViewController.h
//  CodeInputDemo
//
//  Created by Sands_Lee on 2019/1/4.
//  Copyright © 2019年 Sands_Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

// 屏幕宽度高度
#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

// Margin
#define DEFAULT_MARGIN 30.0

// 随机色
#define SLRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

@interface ViewController : UIViewController


@end

