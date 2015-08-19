//
//  WMHamburgerButton.m
//  WMHamburgerButton
//
//  Created by Mark on 15/8/16.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMHamburgerButton.h"

@interface WMHamburgerButton ()
@property (nonatomic, strong) CALayer *topLayer;
@property (nonatomic, strong) CALayer *middleLayer;
@property (nonatomic, strong) CALayer *bottomLayer;
@end

@implementation WMHamburgerButton {
    CGFloat _hamburgerHeight;
    CGFloat _hamburgerWidth;
    CGFloat _hamburgerLayerHeight;
}
@synthesize selected = _selected;

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self layoutSubviews];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _hamburgerWidth = CGRectGetWidth(self.bounds);
    _hamburgerHeight = CGRectGetHeight(self.bounds);
    // MARK:线宽在这定义，可自行修改
    _hamburgerLayerHeight = self.lineHeight > 0 ? self.lineHeight : _hamburgerHeight / 7.0;
    CGFloat cornerRadius =  _hamburgerLayerHeight / 2.0;
    
    self.topLayer.cornerRadius = cornerRadius;
    self.topLayer.frame = CGRectMake(0, CGRectGetMinY(self.bounds), _hamburgerWidth, _hamburgerLayerHeight);
    
    self.middleLayer.cornerRadius = cornerRadius;
    self.middleLayer.frame = CGRectMake(0, CGRectGetMidY(self.bounds)-(_hamburgerLayerHeight/2), _hamburgerWidth, _hamburgerLayerHeight);
    
    self.bottomLayer.cornerRadius = cornerRadius;
    self.bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(self.bounds)-_hamburgerLayerHeight, _hamburgerWidth, _hamburgerLayerHeight);
}

- (void)setup {
    CGColorRef color = [self.tintColor CGColor];
    
    self.topLayer = [CALayer layer];
    self.topLayer.backgroundColor = color;
    
    self.middleLayer = [CALayer layer];
    self.middleLayer.backgroundColor = color;
    
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.backgroundColor = color;
    
    [self.layer addSublayer:self.topLayer];
    [self.layer addSublayer:self.middleLayer];
    [self.layer addSublayer:self.bottomLayer];
    
    [self addTarget:self action:@selector(touchUpInside) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tintColorDidChange {
    CGColorRef color = [self.tintColor CGColor];
    self.topLayer.backgroundColor = color;
    self.middleLayer.backgroundColor = color;
    self.bottomLayer.backgroundColor = color;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self touchUpInside];
}

- (void)touchUpInside {
    if (self.selected) {
        [self animateToMenu];
    } else {
        [self animateToClose];
    }
    _selected = !_selected;
}

- (void)animateToMenu {
    [self removeAllAnimations];
    // top
    CAKeyframeAnimation *topRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    topRotation.values = @[@(M_PI_4), @(-0.1), @0];
    topRotation.calculationMode = kCAAnimationCubic;
    topRotation.keyTimes = @[@0, @0.73, @1.0];
    CAKeyframeAnimation *topPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *startP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight / 2.0)];
    NSValue *endP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerLayerHeight / 2.0)];
    topPosition.values = @[startP, endP];
    topPosition.keyTimes = @[@0, @0.73, @1.0];
    
    CAAnimationGroup *topAnimations = [CAAnimationGroup animation];
    topAnimations.animations = @[topRotation, topPosition];
    topAnimations.removedOnCompletion = NO;
    topAnimations.fillMode = kCAFillModeForwards;
    [self.topLayer addAnimation:topAnimations forKey:@"topAnimation"];
    
    // middle
    CAKeyframeAnimation *middleAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    middleAnim.values = @[@0, @0.8, @1.0];
    middleAnim.removedOnCompletion = NO;
    middleAnim.fillMode = kCAFillModeForwards;
    [self.middleLayer addAnimation:middleAnim forKey:@"middleAnimation"];
    
    // bottom
    CAKeyframeAnimation *bottomRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    bottomRotation.values = @[@(-M_PI_4), @(0.1), @0];
    bottomRotation.calculationMode = kCAAnimationCubic;
    bottomRotation.keyTimes = @[@0, @0.73, @1.0];
    CAKeyframeAnimation *bottomPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    startP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight / 2.0)];
    endP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight - _hamburgerLayerHeight / 2.0)];
    bottomPosition.values = @[startP, endP];
    bottomPosition.keyTimes = @[@0, @0.73, @1.0];
    
    CAAnimationGroup *bottomAnimations = [CAAnimationGroup animation];
    bottomAnimations.animations = @[bottomRotation, bottomPosition];
    bottomAnimations.removedOnCompletion = NO;
    bottomAnimations.fillMode = kCAFillModeForwards;
    [self.bottomLayer addAnimation:bottomAnimations forKey:@"bottomAnimation"];
}

- (void)animateToClose {
    [self removeAllAnimations];
    // top
    CAKeyframeAnimation *topRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    topRotation.values = @[@0, @(M_PI_4), @(M_PI_4*5/4), @(M_PI_4)];
    topRotation.calculationMode = kCAAnimationCubic;
    CAKeyframeAnimation *topPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *startP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerLayerHeight / 2.0)];
    NSValue *endP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight / 2.0)];
    topPosition.values = @[startP, endP];
    
    CAAnimationGroup *topAnimations = [CAAnimationGroup animation];
    topAnimations.animations = @[topRotation, topPosition];
    topAnimations.removedOnCompletion = NO;
    topAnimations.fillMode = kCAFillModeForwards;
    [self.topLayer addAnimation:topAnimations forKey:@"topAnimation"];
    
    // middle
    CAKeyframeAnimation *middleAnim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    middleAnim.values = @[@1.0, @0.2, @0];
    middleAnim.removedOnCompletion = NO;
    middleAnim.fillMode = kCAFillModeForwards;
    [self.middleLayer addAnimation:middleAnim forKey:@"middleAnimation"];
    
    // bottom
    CAKeyframeAnimation *bottomRotation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    bottomRotation.values = @[@0, @(-M_PI_4), @(-M_PI_4*5/4), @(-M_PI_4)];
    bottomRotation.calculationMode = kCAAnimationCubic;
    CAKeyframeAnimation *bottomPosition = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    startP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight - _hamburgerLayerHeight / 2.0)];
    endP = [NSValue valueWithCGPoint:CGPointMake(_hamburgerWidth / 2.0, _hamburgerHeight / 2.0)];
    bottomPosition.values = @[startP, endP];
    bottomPosition.keyTimes = @[@0, @0.73, @1.0];
    
    CAAnimationGroup *bottomAnimations = [CAAnimationGroup animation];
    bottomAnimations.animations = @[bottomRotation, bottomPosition];
    bottomAnimations.removedOnCompletion = NO;
    bottomAnimations.fillMode = kCAFillModeForwards;
    [self.bottomLayer addAnimation:bottomAnimations forKey:@"bottomAnimation"];
}

- (void)removeAllAnimations {
    [self.topLayer removeAllAnimations];
    [self.middleLayer removeAllAnimations];
    [self.bottomLayer removeAllAnimations];
}

@end
