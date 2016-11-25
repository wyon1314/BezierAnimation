//
//  ViewController.m
//  BezierAnimation
//
//  Created by 酷星 on 2016/11/22.
//  Copyright © 2016年 wyon. All rights reserved.
//

#import "ViewController.h"
#import "YGLiveAnimationAlertView.h"
#import "YGCountDownAnimationView.h"
#import "YGRecordVideoButtonView.h"

@interface ViewController ()

@property (nonatomic, strong) YGLiveAnimationAlertView *alertView;
@property (nonatomic, strong) YGCountDownAnimationView *countdownView;
@property (nonatomic, strong) YGRecordVideoButtonView *recordView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.alertView = [[YGLiveAnimationAlertView alloc] initWithFrame:CGRectMake(50, 200, 50, 50)
                                                                                lineWidth:5
                                                                                lineColor:[UIColor redColor]];
    [self.view addSubview:_alertView];
    
    self.countdownView = [[YGCountDownAnimationView alloc] initWithFrame:CGRectMake(150, 200, 50, 50)
                                                                                    totalTime:30.0
                                                                                    lineWidth:5
                                                                                    lineColor:UIColorFromRGBA(0xffeb45, 1)
                                                                                   clickBlock:^{
        
    } completeBlock:^{
        
    }];
    [self.view addSubview:_countdownView];
    
    self.recordView = [[YGRecordVideoButtonView alloc] initWithFrame:CGRectMake(250, 200, 50, 50)
                                                                        defaultLineWidth:2.0
                                                                        defaultLineColor:[UIColor whiteColor]
                                                                               lineWidth:5.0
                                                                               lineColor:UIColorFromRGBA(0xffffff, 0.5)
                                                                       progressLineColor:UIColorFromRGBA(0xffeb45, 1)
                                                                         recordTotalTime:30 recordBlock:^(NSInteger recordSecond) {
        
    }];
    [self.view addSubview:_recordView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 300, 50, 50);
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClick {
    
    [_alertView startProgressAnimation];
    [_countdownView startCountDown];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
