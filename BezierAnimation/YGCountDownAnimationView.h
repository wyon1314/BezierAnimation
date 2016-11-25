//
//  YGCountDownAnimationView.h
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/22.
//  Copyright © 2016年 wyon. All rights reserved.
//
//倒计时视图

#import <UIKit/UIKit.h>


//点击事件回调
typedef void (^SpeedSendGiftClickBlock)();

//30秒后隐藏
typedef void(^CompleteBlock)();

@interface YGCountDownAnimationView : UIView

/**
 *  初始化方法
 *
 *  @frame          坐标大小
 *  @totalTime      倒计时总时间
 *  @lineWidth      线条宽度
 *  @lineColor      线条颜色
 *  @clickBlock     点击view回调
 *  @completeBlock  计时完成回调
 *  
 *  return  对象
 **/
- (instancetype)initWithFrame:(CGRect)frame
                    totalTime:(NSInteger)totalTime
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
                   clickBlock:(SpeedSendGiftClickBlock)clickBlock
                completeBlock:(CompleteBlock)completeBlock;

//开始
- (void)startCountDown;
//结束
- (void)stopCountDown ;

//退到后台
- (void)didEnterBackground;
//进入前台
- (void)didBecomeActive;

@end
