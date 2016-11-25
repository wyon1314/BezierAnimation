//
//  YGRecordVideoButtonView.h
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/24.
//  Copyright © 2016年 wyon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RecordBlock)(NSInteger recordSecond);
@interface YGRecordVideoButtonView : UIView

/**
 *  初始化
 *
 *  @frame
 *  @block  点击录制按钮回调
 *
 *  return
 **/
- (instancetype)initWithFrame:(CGRect)frame
             defaultLineWidth:(CGFloat)dLineWidth
             defaultLineColor:(UIColor *)dLineColor
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
            progressLineColor:(UIColor *)pLineColor
              recordTotalTime:(NSInteger)totalTime
                  recordBlock:(RecordBlock)block;

/**
 *停止录制
 **/
- (void)stopRecordIsEnterBackground:(BOOL)is;

@end
