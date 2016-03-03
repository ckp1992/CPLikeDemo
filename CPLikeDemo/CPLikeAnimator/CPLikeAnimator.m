//
//  CPLikeAnimator.m
//  CPLikeDemo
//
//  Created by Cooper on 3/2/16.
//  Copyright © 2016 Cooper. All rights reserved.
//

#import "CPLikeAnimator.h"

static const CGFloat likeImgWidth            = 30.0;
static const CGFloat likeImgHeight           = 25.0;
static const CFTimeInterval animationTime    = 4.0;

static const int numOfColor                  = 4;
static const NSInteger animateMaxHeight      = 400;

static NSString *const kXDLiveLikeAnimations = @"kCPLikeAnimations";
static NSString *const kForRemoveLayer       = @"kForRemoveLayer";

@interface CPLikeAnimator()

@property (nonatomic, strong) UIView *hostView;

@end

@implementation CPLikeAnimator

#pragma mark -
#pragma mark ------------ Public Properties ------------

+ (CGPoint) converCenterPointToWindow:(UIView*)view {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return [window convertPoint:view.center fromView:view.superview];
}

- (void) animateOnView:(UIView*) view atPoint:(CGPoint) point {
    
    self.hostView = view;
    
    CALayer *likeLayer = [self likeLayer];
    likeLayer.position = point;
    [view.layer addSublayer:likeLayer];
    
    CAAnimationGroup *ani = [self animations];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    [ani setValue:likeLayer forKey:kForRemoveLayer];
    
    [likeLayer addAnimation:ani forKey:kXDLiveLikeAnimations];
    
    [likeLayer performSelector:@selector(removeFromSuperlayer) withObject:nil afterDelay:animationTime+0.1];
    
    
}

#pragma mark -
#pragma mark ------------ CAAnimationDelegate ------------


#pragma mark -
#pragma mark ------------ Private Functions ------------
- (CALayer*) likeLayer {
    
    CALayer *layer = [[CALayer alloc] init];

    int index = arc4random() % numOfColor;
    
    layer.bounds = CGRectMake(0, 0,likeImgWidth ,likeImgHeight);
    layer.contents = (__bridge id)[UIImage imageNamed:[NSString stringWithFormat:@"live_like_%d",index]].CGImage;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.masksToBounds = YES;
    
    return layer;
    
}

- (CAAnimationGroup *) animations {
    
    //渐变
    CABasicAnimation *fade = [CABasicAnimation new];
    fade.keyPath = @"opacity";
    fade.fromValue = @(1);
    fade.toValue = @0;
    fade.duration = animationTime;
    
    //x
    CAKeyframeAnimation *x = [CAKeyframeAnimation new];
    x.keyPath = @"transform.translation.x";
    x.values = [self valuesForXAnimation];//@[@(-15),@(15),@(-15),@(15)];
    x.duration = animationTime;
    x.additive = YES;
    
    //y
    CAKeyframeAnimation *y = [CAKeyframeAnimation new];
    y.keyPath = @"transform.translation.y";
    y.values = [self valuesForYAnimation];//@[@(0),@(-100),@(-150),@(-200)];
    y.duration = animationTime;
    y.additive = YES;
    
    //冒出
    CABasicAnimation *scale = [CABasicAnimation new];
    scale.keyPath = @"transform.scale";
    scale.fromValue = @0;
    scale.toValue = @1;
    scale.duration = 0.25;
    
    //组
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ scale,fade,x,y ];
    group.duration = animationTime;

    return group;
}

- (int) randomIntFrom:(int) min to:(int) max {
    return arc4random() % (max - min + 1) + min;
}

- (NSArray<NSNumber *> *) valuesForXAnimation {
    
    NSMutableArray *array = [[NSMutableArray<NSNumber *> alloc] init];
    
    int arraySize = [self randomIntFrom:5 to:8] - 1;
    int firstValue = [self randomIntFrom:-15 to:15];
    
    [array addObject:@(firstValue)];
    
    for (int i = 1; i < arraySize; i ++) {
        [array addObject:@([self randomIntFrom:-15 to:15])];
    }
    
    return [array copy];
}

- (NSArray<NSNumber *> *) valuesForYAnimation {
    
    NSMutableArray *array = [[NSMutableArray<NSNumber *> alloc] init];
    
    NSInteger arraySize = [self randomIntFrom:3 to:4];
    
    int lastValue = 0;
    for (int i = 0; i < arraySize; i ++) {
        
        int root = (animateMaxHeight/(arraySize*1.0)) * (i+1);
        int max = root + [self randomIntFrom:0 to:10];
        
        int newValue = [self randomIntFrom:lastValue to:max] * -1;
        lastValue = -newValue;
        [array addObject:@(newValue)];
    }
    
    return [array copy];
}
@end
