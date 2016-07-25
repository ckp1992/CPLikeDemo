//
//  CPLikeAnimator.m
//  CPLikeDemo
//
//  Created by Cooper on 3/2/16.
//  Copyright © 2016 Cooper. All rights reserved.
//

#import "CPLikeAnimator.h"

static const CGFloat likeImgWidth         = 36;
static const CGFloat likeImgHeight        = 32;
static const CFTimeInterval animationTime = 4.0;

static const CGFloat xTranslationWidth    = 81;
static const CGFloat xTranslateOffset     = (xTranslationWidth - likeImgWidth) / 2.0;

static const int numOfColor                  = 14;
static const NSInteger animateMaxHeight      = 300;

static NSString *const kXDLiveLikeAnimations = @"kXDLiveLikeAnimations";
static NSString *const kForRemoveLayer       = @"kForRemoveLayer";

#pragma mark -
#pragma mark ------------ Utils ------------

static int _random(int min, int max) {
    return arc4random() % (max - min + 1) + min;
}

@interface CPLikeAnimator()
@end

@implementation CPLikeAnimator

#pragma mark -
#pragma mark ------------ Public Functions ------------

+ (CGPoint) converCenterPointToWindow:(UIView*)view {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return [window convertPoint:view.center fromView:view.superview];
}

- (void) animateOnView:(UIView*) view atPoint:(CGPoint) point {
    
    CALayer *likeLayer = [self p_likeLayer];
    likeLayer.position = point;
    [view.layer addSublayer:likeLayer];
    
    CAAnimationGroup *ani = [self p_animations];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    [ani setValue:likeLayer forKey:kForRemoveLayer];
    
    [likeLayer addAnimation:ani forKey:kXDLiveLikeAnimations];
}

- (void)dealloc {
    
}

#pragma mark -
#pragma mark ------------ CAAnimationDelegate ------------
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CALayer *layer = [anim valueForKey:kForRemoveLayer];
    [layer removeAllAnimations];
    [layer removeFromSuperlayer];
    layer = nil;
}

#pragma mark -
#pragma mark ------------ Private Functions ------------
- (CALayer*) p_likeLayer {
    
    CALayer *layer = [[CALayer alloc] init];
    
    int index = arc4random() % numOfColor;
    
    layer.bounds = CGRectMake(0, 0,likeImgWidth ,likeImgHeight);
    layer.contents = (__bridge id)[UIImage imageNamed:[NSString stringWithFormat:@"live_like_%d",index]].CGImage;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.contentsGravity = kCAGravityResizeAspectFill;
    layer.masksToBounds = YES;
    
    return layer;
    
}

- (CAAnimationGroup *) p_animations {
    
    //渐变
    CABasicAnimation *fade = [CABasicAnimation new];
    fade.keyPath = @"opacity";
    fade.fromValue = @(1);
    fade.toValue = @0;
    fade.duration = animationTime;
    
    //x
    CAKeyframeAnimation *x = [CAKeyframeAnimation new];
    x.keyPath = @"transform.translation.x";
    x.values = [self p_valuesForXAnimation];//@[@(-15),@(15),@(-15),@(15)];
    x.duration = animationTime;
    x.additive = YES;
    
    //y
    CAKeyframeAnimation *y = [CAKeyframeAnimation new];
    y.keyPath = @"transform.translation.y";
    y.values = [self p_valuesForYAnimation];//@[@(0),@(-100),@(-150),@(-200)];
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

- (NSArray<NSNumber *> *) p_valuesForXAnimation {
    
    NSMutableArray *array = [[NSMutableArray<NSNumber *> alloc] init];
    
    int arraySize = _random(5,8) - 1;
    int firstValue = _random(-xTranslateOffset,xTranslateOffset);
    
    [array addObject:@(firstValue)];
    
    for (int i = 1; i < arraySize; i ++) {
        [array addObject:@(_random(-xTranslateOffset,xTranslateOffset))];
    }
    
    return [array mutableCopy];
}

- (NSArray<NSNumber *> *) p_valuesForYAnimation {
    
    NSMutableArray *array = [[NSMutableArray<NSNumber *> alloc] init];
    
    NSInteger arraySize = _random(3, 4);
    
    int lastValue = 0;
    for (int i = 0; i < arraySize; i ++) {
        
        int root = (animateMaxHeight/(arraySize*1.0)) * (i+1);
        int max = root + _random(0, 10);
        
        int newValue = _random(lastValue, max) * -1;
        lastValue = -newValue;
        [array addObject:@(newValue)];
    }
    
    return [array mutableCopy];
}
@end
