//
//  MineViewController.h
//  Mine
//
//  Created by wang yutao on 12-4-6.
//  Copyright 2012 zy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityView;

@interface MineViewController : UIViewController {
	
	IBOutlet UIActivityIndicatorView * sysView;
	
	ActivityView                     * myView;

}

- (IBAction)btnAction:(id)sender;

@end

