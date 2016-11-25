//
//  YGRecordVideoButtonView.m
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/24.
//  Copyright © 2016年 wyon. All rights reserved.
//

#import "YGRecordVideoButtonView.h"

@interface YGRecordVideoButtonView ()

@property (nonatomic, strong) UIColor *dLineColor;//未开始录制状态
@property (nonatomic, assign) CGFloat dLineWidth;

@property (nonatomic, strong) UIColor *lineColor;//开始录制状态
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *pLineColor;//录制进度的颜色
@property (nonatomic, assign) NSInteger totalTime;//录制总时间

@property (nonatomic, strong) UIButton *recordButton;//录制按钮

@property (nonatomic, strong) CAShapeLayer *borderLayer;//录制边框
@property (nonatomic, strong) CAShapeLayer *progressLayer;//设置路径
@property (nonatomic, strong) CABasicAnimation *strokeAnimationStart;//动画

@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) NSInteger times;//录制时间

@property (nonatomic, copy) RecordBlock recordBlock;

@end

@implementation YGRecordVideoButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
             defaultLineWidth:(CGFloat)dLineWidth
             defaultLineColor:(UIColor *)dLineColor
                    lineWidth:(CGFloat)lineWidth
                    lineColor:(UIColor *)lineColor
            progressLineColor:(UIColor *)pLineColor
              recordTotalTime:(NSInteger)totalTime
                  recordBlock:(RecordBlock)block {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //保存相关属性
        self.dLineColor  = dLineColor;
        self.dLineWidth  = dLineWidth;
        self.lineColor   = lineColor;
        self.lineWidth   = lineWidth;
        self.pLineColor  = pLineColor;
        self.totalTime   = totalTime;
        self.recordBlock = block;
        
        [self setUI];
        
    }
    return self;
}

- (void)setUI {
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _recordButton.backgroundColor = UIColorFromRGBA(0xffffff, 0.6);
    [_recordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _recordButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_recordButton];
    
    [_recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.left.top.equalTo(self).offset(5);
        make.right.right.equalTo(self).offset(-5);
    }];
    
}
//设置圆角, 添加图层
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat H = _recordButton.frame.size.height;
    
    _recordButton.layer.masksToBounds = YES;
    _recordButton.layer.cornerRadius  = H / 2.0;
    
    [self.layer addSublayer:self.borderLayer];
}

#pragma mark - 用户交互
- (void)recordButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        //开始录制
        [self startRecord];
        
    } else {
        //结束录制
        [self stopRecordIsEnterBackground:NO];
    }

}
//开始录制
- (void)startRecord {
    //重置录制时间
    _times = 0;
    
    //修改录制按钮
    _recordButton.backgroundColor = UIColorFromRGBA(0xff0000, 0.8);
    
    //修改边框layer
    _borderLayer.lineWidth = self.lineWidth;
    _borderLayer.strokeColor = self.lineColor.CGColor;
    
    //开启定时器
    [self addTimer];
    
    //开启动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.layer addSublayer:self.progressLayer];
        [self.progressLayer addAnimation:self.strokeAnimationStart forKey:nil];
        
    });
    
    //回调33  开始录制
    if (self.recordBlock) {
        _recordBlock(0);
    }
}

//停止录制
- (void)stopRecordIsEnterBackground:(BOOL)is {
    //移除动画
    [self.layer removeAllAnimations];
    [_progressLayer removeAllAnimations];
    [_progressLayer removeFromSuperlayer];
    
    //取消定时器
    [self cancleTimer];
    
    //恢复录制按钮
    _recordButton.selected = NO;
    _recordButton.backgroundColor = UIColorFromRGBA(0xffffff, 0.6);
    [_recordButton setTitle:@"" forState:UIControlStateNormal];
    //恢复边框layer
    _borderLayer.lineWidth = self.dLineWidth;
    _borderLayer.strokeColor = self.dLineColor.CGColor;
    
    //回调 <=30  录制结束
    if (self.recordBlock) {
        
        //如果是进入后台调用的此方法则不回调
        if (!is) {
            _recordBlock(_times);
        }
        
    }
}

#pragma mark - 定时器相关
//添加定时器
- (void)addTimer {
    
    if (_timer == nil) {
        
        _timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(saveRecordTime) userInfo:nil repeats:YES];
        
    }
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)saveRecordTime {
    //时间加 1
    self.times ++;
    
    //30s录制完成  停止录制
    if (self.times >= self.totalTime) {
        [self stopRecordIsEnterBackground:NO];
    } else {
        [_recordButton setTitle:[NSString stringWithFormat:@"%lds",(long)_times] forState:UIControlStateNormal];
    }
}

//取消定时器
- (void)cancleTimer {
    
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - 懒加载方法

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        
        _borderLayer = [CAShapeLayer layer];
        CGMutablePathRef solidPath = CGPathCreateMutable();
        
        _borderLayer.lineWidth = self.dLineWidth;
        _borderLayer.strokeColor = self.dLineColor.CGColor;
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        CGPathAddEllipseInRect(solidPath, nil, CGRectMake(CGRectGetMinX(_recordButton.frame) - 5,  CGRectGetMinY(_recordButton.frame) - 5, CGRectGetWidth(_recordButton.frame)+10, CGRectGetHeight(_recordButton.frame)+10));
        _borderLayer.path = solidPath;
        CGPathRelease(solidPath);
        
    }
    return _borderLayer;
}
- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        
        _progressLayer          = [CAShapeLayer layer];
        _progressLayer.frame    = self.borderLayer.frame;
        _progressLayer.path     = [UIBezierPath bezierPathWithArcCenter:self.recordButton.center
                                                                 radius:(CGRectGetWidth(_recordButton.frame)+10)/2.0
                                                             startAngle:-M_PI_2
                                                               endAngle:-M_PI_2-2*M_PI
                                                              clockwise:NO].CGPath;
        
        _progressLayer.fillColor   = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth   = self.lineWidth;
        _progressLayer.strokeColor = self.pLineColor.CGColor;
        
        _progressLayer.lineCap     = kCALineCapRound;
    }
    
    return _progressLayer;
}
//动画
- (CABasicAnimation *)strokeAnimationStart {
    
    if (!_strokeAnimationStart) {
        
        _strokeAnimationStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        
        _strokeAnimationStart.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        _strokeAnimationStart.duration       = self.totalTime;
        _strokeAnimationStart.fromValue      = @1;
        _strokeAnimationStart.toValue        = @0;
        _strokeAnimationStart.speed          = 1.0;
        
        _strokeAnimationStart.removedOnCompletion = NO;
    }
    
    return _strokeAnimationStart;
}

@end
