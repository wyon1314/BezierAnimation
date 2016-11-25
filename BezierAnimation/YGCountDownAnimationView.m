//
//  YGCountDownAnimationView.m
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/22.
//  Copyright © 2016年 wyon. All rights reserved.
//

#import "YGCountDownAnimationView.h"

@interface YGCountDownAnimationView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;//设置路径
@property (nonatomic, strong) CABasicAnimation *strokeAnimationEnd;//动画
@property (nonatomic, strong) CAAnimationGroup *animationGroup;//动画组
@property (nonatomic, assign) CGFloat progressLineWidth;//线条宽度
@property (nonatomic, strong) UIColor *progressLineColor;//线条颜色
@property (nonatomic, assign) NSInteger totalTime;//倒计时时间
@property (nonatomic,   copy) SpeedSendGiftClickBlock myBlock;//点击回调
@property (nonatomic,   copy) CompleteBlock completeBlock;//完成回调
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) NSInteger progress;

@end

@implementation YGCountDownAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
                    totalTime:(NSInteger)totalTime
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
                   clickBlock:(SpeedSendGiftClickBlock)clickBlock
                completeBlock:(CompleteBlock)completeBlock {
    
    self  = [self initWithFrame:frame];
    
    if (self) {
        //保存参数
        self.progressLineWidth = lineWidth;
        self.progressLineColor = lineColor;
        self.totalTime         = totalTime;
        self.myBlock           = clickBlock;
        self.completeBlock     = completeBlock;
        
        self.backgroundColor   = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        //添加绘制路线
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

//开始
- (void)startCountDown {
    
    [self cancleTimer];
    
    self.hidden         = NO;
    self.progress       = 0;
    
    [self addTimer];
    
    [self.progressLayer addAnimation:self.strokeAnimationEnd forKey:@"group"];
}

//添加定时器
- (void)addTimer {
    
    if (_timer == nil) {
        
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(setProgressValue) userInfo:nil repeats:YES];
    }
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)setProgressValue {
    
    self.progress ++;
    
    if (self.progress >= 30) {
        [self stopCountDown];
    }
}

//停止
- (void)stopCountDown {
    
    if (_timer) {
        
        if (self.strokeAnimationEnd) {
            
            [self.progressLayer removeAllAnimations];
            
//            self.hidden = YES;
            
            [self cancleTimer];
        }
        
        if (self.completeBlock) {
            _completeBlock();
        }
        
    }
}

//设置路径
- (CAShapeLayer *)progressLayer {
    
    if (!_progressLayer) {
        
        _progressLayer          = [CAShapeLayer layer];
        _progressLayer.frame    = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _progressLayer.position = CGPointMake(CGRectGetWidth(self.frame)/2.0, CGRectGetHeight(self.frame)/2.0);
        
        _progressLayer.path     = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.frame)/2.0,
                                                                                    CGRectGetHeight(self.frame)/2.0)
                                                                 radius:(CGRectGetWidth(self.frame) - self.progressLineWidth)/2.0
                                                             startAngle:-M_PI_2
                                                               endAngle:-M_PI_2+2*M_PI
                                                              clockwise:YES].CGPath;
        
        _progressLayer.fillColor   = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth   = self.progressLineWidth;
        _progressLayer.strokeColor = self.progressLineColor.CGColor;
        _progressLayer.strokeEnd   = 0;
        _progressLayer.strokeStart = 0;
        _progressLayer.lineCap     = kCALineCapRound;
    }
    
    return _progressLayer;
}

//动画
- (CABasicAnimation *)strokeAnimationEnd {
    
    if (!_strokeAnimationEnd) {
        
        _strokeAnimationEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        _strokeAnimationEnd.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _strokeAnimationEnd.duration       = self.totalTime;
        _strokeAnimationEnd.fromValue      = @1;
        _strokeAnimationEnd.toValue        = @0;
        _strokeAnimationEnd.speed          = 1.0;
        
        _strokeAnimationEnd.removedOnCompletion = NO;
    }
    
    return _strokeAnimationEnd;
}

//取消定时器
- (void)cancleTimer {
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    UIColor *color = UIColorFromRGBA(0xffffff, 0.5);
    
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect)/2.0, CGRectGetHeight(rect)/2.0)
                                                         radius:(CGRectGetWidth(rect) - _progressLineWidth)/2.0
                                                     startAngle:0
                                                       endAngle:M_PI*2
                                                      clockwise:YES];
    
    aPath.lineWidth     = _progressLineWidth;
    aPath.lineCapStyle  = kCGLineCapRound;
    aPath.lineJoinStyle = kCGLineJoinRound;
    
    [aPath stroke];
}

- (void)tap {
    [self startCountDown];
}

//退到后台
- (void)didEnterBackground {
    //记录暂停时间
    CFTimeInterval pauseTime      = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil];
    //设置动画速度为0
    self.progressLayer.speed      = 0;
    //设置动画的偏移时间
    self.progressLayer.timeOffset = pauseTime;
    
    //暂停定时器
    [_timer setFireDate:[NSDate distantFuture]];
    
}

//进入前台
- (void)didBecomeActive {
    //暂停的时间
    CFTimeInterval pauseTime = self.progressLayer.timeOffset;
    
    //设置动画速度为1
    self.progressLayer.speed      = 1;
    //重置偏移时间
    self.progressLayer.timeOffset = 0;
    //重置开始时间
    self.progressLayer.beginTime  = 0;
    //计算开始时间
    CFTimeInterval timeSincePause = [self.progressLayer convertTime:CACurrentMediaTime() fromLayer:nil] - pauseTime;
    //设置开始时间
    self.progressLayer.beginTime  = timeSincePause;
    
    //开始定时器
    [_timer setFireDate:[NSDate distantPast]];
}

@end
