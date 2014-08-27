//
//  YMLSideMenuViewControllerDelegate.h
//  HouseParty
//
//  Created by கார்த்திக் கேயன் on 19/12/13.
//  Copyright (c) 2013 YMediaLabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YMLSideMenuViewControllerDelegate <NSObject>

@optional
- (void) disableControlsForSideMenuOpen;
- (void) enableControlsForSideMenuClose;

@end
