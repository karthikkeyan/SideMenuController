//
//  YMLSideMenuViewController.h
//  HouseParty
//
//  Created by கார்த்திக் கேயன் on 20/11/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import "YMLSideMenuViewControllerDelegate.h"
#import "HPViewController.h"

#define SIDEMENU_WIDTH          275

@interface YMLSideMenuViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isSideBarOpened;

@property (nonatomic, strong) UIViewController<YMLSideMenuViewControllerDelegate> *mainViewController;
@property (nonatomic, strong) UIViewController<YMLSideMenuViewControllerDelegate> *sideMenuController;
@property (nonatomic, strong) NSArray *panEnabledViewControllersClassName;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void) setMainViewController:(UIViewController<YMLSideMenuViewControllerDelegate> *)mainViewController needsNavigationController:(BOOL)navigationController;
- (void) openSideBarWithBouncing:(BOOL)bouncing completion:(void (^)(void))completion;
- (void) closeSideBarWithBouncing:(BOOL)bouncing completion:(void (^)(void))completion;
- (void) sideMenuOpened;
- (void) sideMenuClosed;

@end
