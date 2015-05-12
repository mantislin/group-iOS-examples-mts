//
//  ViewController.m
//  test-CAKeyFrameAnimation
//
//  Created by MantisLin on 5/12/15.
//  Copyright (c) 2015 mts. All rights reserved.
//

#import "ViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "ViewCtrler.h"

@interface ViewController ()
@property (assign, nonatomic) BOOL animationStarted;
@property (assign, nonatomic) CGRect firstRect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self myInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (CGRectIsEmpty(self.firstRect)) {
        self.firstRect = self.label.frame;
    }

    if (!self.animationStarted)
        [self playLayer];
    else
        [self resumeLayer:self.label.layer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self pauseLayer:self.label.layer];
}

#pragma mark - customize

- (void)myInit
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setTitle:@"JUMP" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpTo:)
        forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bbi;
}

- (void)playLayer
{
    if (!self.animationStarted) {

        self.animationStarted = YES;

        CGFloat y = self.firstRect.origin.y;
        CGFloat hh = self.firstRect.size.height / 2;
        y += hh;

        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.y";
        animation.values = @[ @(y - 0), @(y + 50), @(y - 0), @(y - 50), @(y - 0) ];
        animation.duration = 4.0f;
        animation.repeatCount = HUGE_VAL;
        
        [self.label.layer addAnimation:animation forKey:@"move"];

    } else {

        [self resumeLayer:self.label.layer];
    }
}

- (void)pauseLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

#pragma mark - actions

- (IBAction)jumpTo:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewCtrler *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"vc1"];
    [self.navigationController pushViewController:vc1 animated:YES];
    NSLog(@"storyboard = %@", storyboard);
}

@end
