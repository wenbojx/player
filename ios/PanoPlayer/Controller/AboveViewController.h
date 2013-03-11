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
    //UIImage *UIimage;
    UIButton *closeBt;
    int width;
    //UIActivityIndicatorView *progressInd;
    UIProgressView *imageProgressIndicator;
    UILabel *loading;
}

@property(retain, nonatomic)ImageCropper *imageView;
//@property(retain, nonatomic)UIImage *UIimage;
@property(retain, nonatomic)UIButton *closeBt;
//@property(retain, nonatomic)UIActivityIndicatorView *progressInd;
@property(nonatomic, assign) UIProgressView *imageProgressIndicator;
@property(nonatomic, assign)UILabel *loading;

-(void) setImage:(UIImage *) image;
-(void) setCloseButton;
-(void)downloadHotImage:(NSString *)imagePath;
    
-(IBAction)onClickButton:(id)sender;
@end

