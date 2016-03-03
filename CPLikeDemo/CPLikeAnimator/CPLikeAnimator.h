//
//  CPLikeAnimator.h
//  CPLikeDemo
//
//  Created by Cooper on 3/2/16.
//  Copyright © 2016 Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPLikeAnimator : NSObject

+ (CGPoint) converCenterPointToWindow:(UIView*)view;

- (void) animateOnView:(UIView*) view atPoint:(CGPoint) point;

@end
