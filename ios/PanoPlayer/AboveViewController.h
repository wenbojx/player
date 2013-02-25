//
//  AboveViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-2-22.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ImageCropper.h"

@interface AboveViewController : UIView {
    UIImage *UIimage;
}

@property(retain, nonatomic)ImageCropper *imageView;
@property(retain, nonatomic)UIImage *UIimage;

-(void) setImage:(UIImage *) image;
-(IBAction)onClickButton:(id)sender;
@end

