//
//  YMLSideMenuViewController.m
//  HouseParty
//
//  Created by கார்த்திக் கேயன் on 20/11/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "YMLSideMenuViewController.h"
#import "UIView+Extension.h"

#define SCALE_SIZE          0.9

@interface YMLSideMenuViewController ()

@property (nonatomic, assign) BOOL isSideBarOpening, needsNavigaionForMainController;

@end

@implementation YMLSideMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIMethods

- (void) UISetupViews {
//    [super UISetupViews];
    
    [self UICreateSideMenuVC];
    [self UICreateMainVC];
}

- (void) UICreateSideMenuVC {
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    rect.origin.y = 0;
    rect.size.height = self.view.innerHeight;
    
    [[_sideMenuController view] setFrame:rect];
    [self.view addSubview:_sideMenuController.view];
    [self addChildViewController:_sideMenuController];
    [_sideMenuController didMoveToParentViewController:self];
    
    [_sideMenuController.view setTransform:CGAffineTransformMakeScale(SCALE_SIZE, SCALE_SIZE)];
}

- (void) UICreateMainVC {
    if (_needsNavigaionForMainController) {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
        [self.view addSubview:navigationController.view];
        [self addChildViewController:navigationController];
        [navigationController didMoveToParentViewController:self];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [_panGesture setDelegate:self];
        [_panGesture setCancelsTouchesInView:NO];
        [navigationController.view addGestureRecognizer:_panGesture];
    }
    else {
        [self.view addSubview:_mainViewController.view];
        [self addChildViewController:_mainViewController];
        [_mainViewController didMoveToParentViewController:self];
        
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [_panGesture setDelegate:self];
        [_panGesture setCancelsTouchesInView:NO];
        [_mainViewController.view addGestureRecognizer:_panGesture];
    }
}


#pragma mark - Public Methods

- (void) setMainViewController:(UIViewController<YMLSideMenuViewControllerDelegate> *)mainViewController needsNavigationController:(BOOL)navigationController {
    if (_mainViewController != mainViewController) {
        _mainViewController = mainViewController;
        
        _needsNavigaionForMainController = navigationController;
    }
}

- (void) openSideBarWithBouncing:(BOOL)bouncing completion:(void (^)(void))completion {
    CGRect rect = [[_mainViewController view] frame];
    if (_needsNavigaionForMainController) {
        rect = [[[_mainViewController navigationController] view] frame];
    }
    
    rect.origin.x = SIDEMENU_WIDTH - 2;
    _isSideBarOpened = YES;
    _isSideBarOpening = NO;
    
    
    [self disableControlsForSideMenuOpen];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        YMLSideMenuViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.needsNavigaionForMainController) {
                [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
            }
            else {
                [[strongSelf.mainViewController view] setFrame:rect];
            }
            
            [strongSelf.sideMenuController.view setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
        }
    } completion:^(BOOL finished) {
        YMLSideMenuViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (bouncing) {
                [strongSelf sideBarOpenBounce];
            }
            
            [strongSelf sideMenuOpened];
        }
        
        if (completion) {
            completion();
        }
    }];
}

- (void) closeSideBarWithBouncing:(BOOL)bouncing completion:(void (^)(void))completion {
    CGRect rect = [[_mainViewController view] frame];
    if (_needsNavigaionForMainController) {
        rect = [[[_mainViewController navigationController] view] frame];
    }
    
    rect.origin.x = 0;
    _isSideBarOpened = NO;
    _isSideBarOpening = NO;
    
    [self enableControlsForSideMenuClose];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        YMLSideMenuViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (strongSelf.needsNavigaionForMainController) {
                [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
            }
            else {
                [[strongSelf.mainViewController view] setFrame:rect];
            }
            
            [strongSelf.sideMenuController.view setTransform:CGAffineTransformMakeScale(SCALE_SIZE, SCALE_SIZE)];
        }
    } completion:^(BOOL finished) {
        YMLSideMenuViewController *strongSelf = weakSelf;
        if (strongSelf) {
            if (bouncing) {
                [strongSelf sideBarCloseBounce];
            }
            
            [strongSelf sideMenuClosed];
        }
        
        if (completion) {
            completion();
        }
    }];
}

- (void) sideMenuOpened {
    //
}

- (void) sideMenuClosed {
    //
}


#pragma mark - Gesture

- (void) panGesture:(UIPanGestureRecognizer *)gesture {
    static CGPoint beginPoint, previousPoint;
    
    CGPoint point = [gesture locationInView:[gesture view]];
    CGPoint velocity = [gesture velocityInView:[gesture view]];
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        beginPoint = point;
    }
    
    _isSideBarOpening = YES;
    
    UIViewController *controllerToUse;
    if (_needsNavigaionForMainController) {
        controllerToUse = _mainViewController.navigationController;
        
        NSString *viewControllerClassName = NSStringFromClass([[(UINavigationController *)controllerToUse topViewController] class]);
        if (![_panEnabledViewControllersClassName containsObject:viewControllerClassName]) {
            return;
        }
    }
    else {
        controllerToUse = _mainViewController;
    }
    
    point = [[controllerToUse view] convertPoint:point toView:[self view]];
    
    if ([gesture state] == UIGestureRecognizerStateBegan) {
        [gesture setCancelsTouchesInView:YES];
        [self disableControlsForSideMenuOpen];
        beginPoint = point;
        previousPoint = beginPoint;
    }
    else if ([gesture state] == UIGestureRecognizerStateChanged) {
        CGRect rect = [[controllerToUse view] frame];
        // Open
        if (velocity.x > 0) {
            CGFloat delta = point.x - previousPoint.x;
            rect.origin.x += delta;
        }
        // Close
        else if (velocity.x < 0) {
            CGFloat delta = previousPoint.x - point.x;
            rect.origin.x -= delta;
        }
        
        if (rect.origin.x < SIDEMENU_WIDTH && rect.origin.x > 0) {
            [[controllerToUse view] setFrame:rect];
            previousPoint = point;
        }
        
        CGFloat difference = (1.0 - SCALE_SIZE) * (rect.origin.x/SIDEMENU_WIDTH);
        [_sideMenuController.view setTransform:CGAffineTransformMakeScale(SCALE_SIZE + difference, SCALE_SIZE + difference)];
    }
    else if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
        CGRect rect = [[controllerToUse view] frame];
        
        BOOL needsBouncing = YES;
        if (rect.origin.x < 50 || rect.origin.x > (SIDEMENU_WIDTH - 50)) {
            needsBouncing = NO;
        }
        
        //        20 > 200 && notopen
        if (((!_isSideBarOpened) || (beginPoint.x >= (SIDEMENU_WIDTH - 50) && _isSideBarOpened)) && ((velocity.x > 500) || (velocity.x < -500))) {
            // Open
            if (velocity.x > 500) {
                [self openSideBarWithBouncing:needsBouncing completion:nil];
            }
            // Close
            else if (velocity.x < -500) {
                [self closeSideBarWithBouncing:needsBouncing completion:nil];
            }
        }
        // While Close
        else if (velocity.x < 0) {
            if (rect.origin.x <= SIDEMENU_WIDTH/2) {
                [self closeSideBarWithBouncing:needsBouncing completion:nil];
            }
            else {
                [self openSideBarWithBouncing:needsBouncing completion:nil];
            }
        }
        // While Open
        else {
            if (rect.origin.x >= SIDEMENU_WIDTH/2) {
                [self openSideBarWithBouncing:needsBouncing completion:nil];
            }
            else {
                [self closeSideBarWithBouncing:needsBouncing completion:nil];
            }
        }
        
        beginPoint = CGPointZero;
        _isSideBarOpening = NO;
    }
    else {
        [gesture setCancelsTouchesInView:NO];
        
        _isSideBarOpening = NO;
        beginPoint = CGPointZero;
        previousPoint = CGPointZero;
        [self enableControlsForSideMenuClose];
    }
}


#pragma mark - Gesture Delegate

//- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    if (gestureRecognizer == _panGesture && [[otherGestureRecognizer view] isKindOfClass:[UIScrollView class]]) {
//        return YES;
//    }
//
//    return NO;
//}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    [self enableControlsForSideMenuClose];
    
    return NO;
}


#pragma mark - Private Methods

- (void) disableControlsForSideMenuOpen {
    if ([_mainViewController respondsToSelector:@selector(disableControlsForSideMenuOpen)]) {
        [_mainViewController disableControlsForSideMenuOpen];
    }
    
    if ([_sideMenuController respondsToSelector:@selector(disableControlsForSideMenuOpen)]) {
        [_sideMenuController disableControlsForSideMenuOpen];
    }
    
    if (_needsNavigaionForMainController &&
        [[[_mainViewController navigationController] topViewController] conformsToProtocol:@protocol(YMLSideMenuViewControllerDelegate)]) {
        UIViewController *controller = [[_mainViewController navigationController] topViewController];
        
        if ([controller respondsToSelector:@selector(disableControlsForSideMenuOpen)]) {
            [(id<YMLSideMenuViewControllerDelegate>)controller disableControlsForSideMenuOpen];
        }
    }
}

- (void) enableControlsForSideMenuClose {
    if ([_mainViewController respondsToSelector:@selector(enableControlsForSideMenuClose)]) {
        [_mainViewController enableControlsForSideMenuClose];
    }
    
    if ([_sideMenuController respondsToSelector:@selector(enableControlsForSideMenuClose)]) {
        [_sideMenuController enableControlsForSideMenuClose];
    }
    
    if (_needsNavigaionForMainController &&
        [[[_mainViewController navigationController] topViewController] conformsToProtocol:@protocol(YMLSideMenuViewControllerDelegate)]) {
        UIViewController *controller = [[_mainViewController navigationController] topViewController];
        
        if ([controller respondsToSelector:@selector(enableControlsForSideMenuClose)]) {
            [(id<YMLSideMenuViewControllerDelegate>)controller enableControlsForSideMenuClose];
        }
    }
}


- (void) sideBarOpenBounce {
    return;
    
    __block CGRect rect = [[_mainViewController view] frame];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         YMLSideMenuViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             rect.origin.x = SIDEMENU_WIDTH - 10;
                             
                             if (strongSelf.needsNavigaionForMainController) {
                                 [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
                             }
                             else {
                                 [[strongSelf.mainViewController view] setFrame:rect];
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              YMLSideMenuViewController *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  rect.origin.x = SIDEMENU_WIDTH - 2;
                                                  if (strongSelf.needsNavigaionForMainController) {
                                                      [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
                                                  }
                                                  else {
                                                      [[strongSelf.mainViewController view] setFrame:rect];
                                                  }
                                              }
                                          }
                                          completion:nil];
                     }];
}

- (void) sideBarCloseBounce {
    return;
    
    __block CGRect rect = [[_mainViewController view] frame];
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         YMLSideMenuViewController *strongSelf = weakSelf;
                         if (strongSelf) {
                             rect.origin.x += 10;
                             if (strongSelf.needsNavigaionForMainController) {
                                 [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
                             }
                             else {
                                 [[strongSelf.mainViewController view] setFrame:rect];
                             }
                         }
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              YMLSideMenuViewController *strongSelf = weakSelf;
                                              if (strongSelf) {
                                                  rect.origin.x = 0;
                                                  if (strongSelf.needsNavigaionForMainController) {
                                                      [[[strongSelf.mainViewController navigationController] view] setFrame:rect];
                                                  }
                                                  else {
                                                      [[strongSelf.mainViewController view] setFrame:rect];
                                                  }
                                              }
                                          }
                                          completion:nil];
                     }];
}


#pragma mark - Dealloc

- (void) dealloc {
    _mainViewController = nil;
    _sideMenuController = nil;
}

@end
