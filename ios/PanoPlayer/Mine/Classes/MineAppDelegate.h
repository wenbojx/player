//
//  MineAppDelegate.h
//  Mine
//
//  Created by wang yutao on 12-4-6.
//  Copyright 2012 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineViewController;

@interface MineAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MineViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MineViewController *viewController;

@end

