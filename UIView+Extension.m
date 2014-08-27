//
//  UIView+Extension.m
//  Tourean
//
//  Created by Karthik Keyan B on 10/25/12.
//  Copyright (c) 2012 vivekrajanna@gmail.com. All rights reserved.
//

#import "UIView+Extension.h"
#import "YMLTextField.h"

#import <QuartzCore/QuartzCore.h>

@implementation UIView (Extension)

- (UIImage *) imageByRenderingView {
	CGFloat oldAlpha = self.alpha;
    BOOL previousHiddenState = [self isHidden];
    
	self.alpha = 1;
    [self setHidden:NO];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    }
    else {
        UIGraphicsBeginImageContext(self.bounds.size);
    }
	[[self layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    [self setHidden:previousHiddenState];
	self.alpha = oldAlpha;
	
	return resultingImage;
}

- (UIImage *) imageByRenderAndFlipView {
    CGFloat oldAlpha = self.alpha;
    BOOL previousHiddenState = [self isHidden];
    
	self.alpha = 1;
    [self setHidden:NO];
	
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    }
    else {
        UIGraphicsBeginImageContext(self.bounds.size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, self.frame.size.height);
    CGContextConcatCTM(context, flipVertical);
    [self.layer renderInContext:context];
    
	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
	[self setHidden:previousHiddenState];
	self.alpha = oldAlpha;
	
	return resultingImage;
}

- (void) applyPropertyFromView:(UIView *)fromView {
    if ([self class] == [fromView class] && ([self isKindOfClass:[UILabel class]] || [self superclass] == [UILabel class])) {
        [(UILabel *)self setFont:[(UILabel *)fromView font]];
        [(UILabel *)self setTextColor:[(UILabel *)fromView textColor]];
        [(UILabel *)self setShadowColor:[(UILabel *)fromView shadowColor]];
        [(UILabel *)self setShadowOffset:[(UILabel *)fromView shadowOffset]];
        [(UILabel *)self setBackgroundColor:[(UILabel *)fromView backgroundColor]];
        [(UILabel *)self setTextAlignment:[(UILabel *)fromView textAlignment]];
        [(UILabel *)self setUserInteractionEnabled:[(UILabel *)fromView isUserInteractionEnabled]];
    }
    else if ([self class] == [fromView class] && ([self isKindOfClass:[UITextField class]] || [self superclass] == [UITextField class])) {
        [(UITextField *)self setDelegate:[(UITextField *)fromView delegate]];
        [(UITextField *)self setBackground:[(UITextField *)fromView background]];
        [(UITextField *)self setFont:[(UITextField *)fromView font]];
        [(UITextField *)self setTextColor:[(UITextField *)fromView textColor]];
        [(UITextField *)self setContentVerticalAlignment:[(UITextField *)fromView contentVerticalAlignment]];
        [(UITextField *)self setClearButtonMode:[(UITextField *)fromView clearButtonMode]];
        [(UITextField *)self setAutocapitalizationType:[(UITextField *)fromView autocapitalizationType]];
        [(UITextField *)self setAutocorrectionType:[(UITextField *)fromView autocorrectionType]];
        [(UITextField *)self setReturnKeyType:[(UITextField *)fromView returnKeyType]];
        
        if ([self isKindOfClass:[YMLTextField class]]) {
            [(YMLTextField *)self setTextInsets:[(YMLTextField *)fromView textInsets]];
            [(YMLTextField *)self setPlaceHolderTextColor:[(YMLTextField *)fromView placeHolderTextColor]];
        }
    }
}

- (CGFloat) top {
    return self.frame.origin.y;
}

- (CGFloat) bottom {
    return self.top + self.height;
}

- (CGFloat) right {
    return self.left + self.width;
}

- (CGFloat) left {
    return self.frame.origin.x;
}

- (CGFloat) innerWidth {
    return self.bounds.size.width;
}

- (CGFloat) width {
    return self.frame.size.width;
}

- (CGFloat) innerHeight {
    return self.bounds.size.height;
}

- (CGFloat) height {
    return self.frame.size.height;
}

- (void) resignSubviewsFirstResponder {
    for (UIView *subView in [self subviews]) {
        if ([subView isFirstResponder]) {
            [subView resignFirstResponder];
        }
    }
}

- (void) makeSubViewVerticalCenter:(UIView *)subView {
    CGRect rect = [subView frame];
    rect.origin.y = ((self.height - rect.size.height) * 0.5);
    [subView setFrame:rect];
}

- (void) makeSubViewHorizontalCenter:(UIView *)subView {
    CGRect rect = [subView frame];
    rect.origin.x = ((self.width - rect.size.width) * 0.5);
    [subView setFrame:rect];
}

- (void) raiseUpForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y -= keyBoardRect.size.height;
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) raiseUpForNotification:(NSNotification *)notification
                     constraint:(NSLayoutConstraint *)constraint
                      superView:(UIView *)superView
                     isIncrease:(BOOL)isIncrease {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    if (isIncrease) {
        constraint.constant += keyBoardRect.size.height;
    }
    else {
        constraint.constant -= keyBoardRect.size.height;
    }
    [superView setNeedsUpdateConstraints];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [superView layoutIfNeeded];
    [UIView commitAnimations];
}

- (void) raiseUpHalfForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y -= (keyBoardRect.size.height/2);
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) raiseUpQuaterForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y -= (keyBoardRect.size.height/4);
    [self setFrame:viewRect];
    [UIView commitAnimations];
}


- (void) fallDownForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y += keyBoardRect.size.height;
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) fallDownForNotification:(NSNotification *)notification constraint:(NSLayoutConstraint *)constraint superView:(UIView *)superView isIncrease:(BOOL)isIncrease {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    if (isIncrease) {
        constraint.constant += keyBoardRect.size.height;
    }
    else {
        constraint.constant -= keyBoardRect.size.height;
    }
    
    [superView setNeedsUpdateConstraints];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [superView layoutIfNeeded];
    [UIView commitAnimations];
}

- (void) fallDownHalfForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y += (keyBoardRect.size.height/2);
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) fallDownQuaterForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveLinear;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.origin.y += (keyBoardRect.size.height/4);
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) shrinkForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseIn;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    else if ([[notification userInfo] objectForKey:@"animationCurve"]) {
        animationCurve = [[[notification userInfo] objectForKey:@"animationCurve"] integerValue];
    }

    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    else if ([[notification userInfo] objectForKey:@"rect"]) {
        keyBoardRect = [[[notification userInfo] objectForKey:@"rect"] CGRectValue];
    }

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.size.height -= keyBoardRect.size.height;
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) resizeForNotification:(NSNotification *)notification {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseOut;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    else if ([[notification userInfo] objectForKey:@"animationCurve"]) {
        animationCurve = [[[notification userInfo] objectForKey:@"animationCurve"] integerValue];
    }
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    else if ([[notification userInfo] objectForKey:@"rect"]) {
        keyBoardRect = [[[notification userInfo] objectForKey:@"rect"] CGRectValue];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGRect viewRect = [self frame];
    viewRect.size.height += keyBoardRect.size.height;
    [self setFrame:viewRect];
    [UIView commitAnimations];
}

- (void) resizeForNotification:(NSNotification *)notification
                    constraint:(NSLayoutConstraint *)constraint
                     superView:(UIView *)superView
                    isIncrease:(BOOL)isIncrease {
    CGFloat duration = 0.25;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey]) {
        duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    }
    
    UIViewAnimationCurve animationCurve = UIViewAnimationCurveEaseIn;
    if ([[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey]) {
        animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    }
    else if ([[notification userInfo] objectForKey:@"animationCurve"]) {
        animationCurve = [[[notification userInfo] objectForKey:@"animationCurve"] integerValue];
    }
    
    
    CGRect keyBoardRect = CGRectZero;
    if ([[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey]) {
        [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyBoardRect];
    }
    else if ([[notification userInfo] objectForKey:@"rect"]) {
        keyBoardRect = [[[notification userInfo] objectForKey:@"rect"] CGRectValue];
    }
    
    if (isIncrease) {
        constraint.constant += keyBoardRect.size.height;
    }
    else {
        constraint.constant -= keyBoardRect.size.height;
    }
    
    [superView setNeedsUpdateConstraints];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [superView layoutIfNeeded];
    [UIView commitAnimations];
}

- (void) springAnimationForKeyPath:(NSString *)path duration:(CGFloat)animationDuration {
    int steps = animationDuration * 60; // 60 FPS
    
    double value = 0;
    float e = 2.71;
    
    CGFloat maxX = 2.0;
    CGFloat midX = 1.0;
    
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps + 1];
    for (int times = 0; times <= steps; times++) {
        CGFloat factor = (((CGFloat)times) / (CGFloat)steps) * 100;
        value = -maxX * pow(e, -0.055 * factor) * cos(0.08 * factor) + midX;
        
        if (value > 0) {
            [values addObject:[NSNumber numberWithFloat:value]];
        }
    }
    
    // @"transform.scale"
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setDuration:animationDuration];
    [animation setValues:values];
    [[self layer] addAnimation:animation forKey:nil];
}

- (void) easeMoveAnimationForKeyPath:(NSString *)path move:(CGFloat)move duration:(CGFloat)animationDuration delay:(NSTimeInterval)delay completion:(void (^)(void))completion {
    CGPoint oldPosition = [self.layer.presentationLayer position];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:path];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setDuration:animationDuration];
    
    if ([path isEqualToString:@"position.x"]) {
        [animation setFromValue:@(oldPosition.x)];
        [animation setToValue:@(oldPosition.x + move)];
    }
    else {
        [animation setFromValue:@(oldPosition.y)];
        [animation setToValue:@(oldPosition.y + move)];
    }
    
    [animation setBeginTime:CACurrentMediaTime() + delay];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    [[self layer] addAnimation:animation forKey:nil];
    
    if (completion) {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDuration * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), completion);
    }
}

@end
