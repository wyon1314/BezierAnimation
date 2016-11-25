//
//  YGLiveAnimationAlertView.m
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/22.
//  Copyright © 2016年 wyon. All rights reserved.
//

#import "YGLiveAnimationAlertView.h"

@interface YGLiveAnimationAlertView ()

@property (strong, nonatomic) CAShapeLayer *progressLayer;//进度

@property (strong, nonatomic) CABasicAnimation *rotateAnimation;//动画

@property (assign, nonatomic) CGFloat progressLineWidth;//边框宽度
@property (strong, nonatomic) UIColor * progressLineColor;//边框颜色


@end

@implementation YGLiveAnimationAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//初始化
- (instancetype)initWithFrame:(CGRect)frame lineWidth:(CGFloat)lineWidth  lineColor:(UIColor *)lineColor {
    
    self  = [self initWithFrame:frame];
    
    if (self) {
        
        self.progressLineWidth = lineWidth;
        self.progressLineColor = lineColor;
        
        [self.layer addSublayer:self.progressLayer];
    }
    
    return self;
}

//开始动画
- (void)startProgressAnimation {
    [self.progressLayer addAnimation:self.rotateAnimation forKey:@"group"];
}

//画进度
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        
        CGFloat width           = CGRectGetWidth(self.frame);
        CGFloat height          = CGRectGetHeight(self.frame);
        
        _progressLayer.frame    = CGRectMake(0, 0, width, height);
        _progressLayer.position = CGPointMake(width/2.0,height/2.0);
        
        UIBezierPath *aPath     = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0, height/2.0)
                                                                 radius:(width - self.progressLineWidth)/2.0
                                                             startAngle:0
                                                               endAngle:M_PI_4 * 7
                                                              clockwise:YES];
        [aPath stroke];
        
        _progressLayer.path        = aPath.CGPath;
        _progressLayer.fillColor   = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth   = self.progressLineWidth;
        _progressLayer.strokeColor = self.progressLineColor.CGColor;
        _progressLayer.lineCap     = kCALineCapRound;
    }
    return _progressLayer;
}

- (CABasicAnimation *)rotateAnimation {
    if (!_rotateAnimation) {
        _rotateAnimation                     = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotateAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _rotateAnimation.toValue             = @(M_PI * 2);
        _rotateAnimation.fromValue           = @(0);
        _rotateAnimation.duration            = 1;
        _rotateAnimation.removedOnCompletion = NO;
        _rotateAnimation.repeatCount         = FLT_MAX;
    }
    return _rotateAnimation;
}



@end
