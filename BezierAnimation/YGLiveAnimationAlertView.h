//
//  YGLiveAnimationAlertView.h
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/22.
//  Copyright © 2016年 wyon. All rights reserved.
//
//正在直播提示视图

#import <UIKit/UIKit.h>

@interface YGLiveAnimationAlertView : UIView

/**
 *  初始化
 *
 *  @frame      位置大小
 *  @lineWidth  线条宽度
 *  @lineColor  线条颜色
 *
 *  return  对象
 **/
- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth  lineColor:(UIColor *)lineColor;

/**
 *
 *开始动画
 *
 **/
- (void)startProgressAnimation;

@end
