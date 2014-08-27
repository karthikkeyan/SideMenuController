//
//  UIView+Extension.h
//  Tourean
//
//  Created by Karthik Keyan B on 10/25/12.
//  Copyright (c) 2012 vivekrajanna@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

- (UIImage *) imageByRenderingView;
- (UIImage *) imageByRenderAndFlipView;
- (void) applyPropertyFromView:(UIView *)fromView;

- (CGFloat) top;
- (CGFloat) bottom;
- (CGFloat) right;
- (CGFloat) left;
- (CGFloat) innerWidth;
- (CGFloat) width;
- (CGFloat) innerHeight;
- (CGFloat) height;

- (void) resignSubviewsFirstResponder;
- (void) makeSubViewVerticalCenter:(UIView *)subView;
- (void) makeSubViewHorizontalCenter:(UIView *)subView;

- (void) raiseUpForNotification:(NSNotification *)notification;
- (void) raiseUpForNotification:(NSNotification *)notification constraint:(NSLayoutConstraint *)constraint superView:(UIView *)superView isIncrease:(BOOL)isIncrease;
- (void) raiseUpHalfForNotification:(NSNotification *)notification;
- (void) raiseUpQuaterForNotification:(NSNotification *)notification;

- (void) fallDownForNotification:(NSNotification *)notification;
- (void) fallDownForNotification:(NSNotification *)notification constraint:(NSLayoutConstraint *)constraint superView:(UIView *)superView isIncrease:(BOOL)isIncrease;
- (void) fallDownHalfForNotification:(NSNotification *)notification;
- (void) fallDownQuaterForNotification:(NSNotification *)notification;

- (void) shrinkForNotification:(NSNotification *)notification;
- (void) resizeForNotification:(NSNotification *)notification;
- (void) resizeForNotification:(NSNotification *)notification
                    constraint:(NSLayoutConstraint *)constraint
                     superView:(UIView *)superView
                    isIncrease:(BOOL)isIncrease;

- (void) springAnimationForKeyPath:(NSString *)path duration:(CGFloat)animationDuration;
- (void) easeMoveAnimationForKeyPath:(NSString *)path move:(CGFloat)move duration:(CGFloat)animationDuration delay:(NSTimeInterval)delay completion:(void (^)(void))completion ;

@end
