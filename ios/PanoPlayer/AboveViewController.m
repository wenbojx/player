//
//  AboveViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-2-22.
//
//

#import "AboveViewController.h"

@interface AboveViewController ()

@end

@implementation AboveViewController
@synthesize imageView;
@synthesize UIimage;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 10;    //设置弹出框为圆角视图
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 3;   //设置弹出框视图边框宽度
        self.layer.borderColor = [[UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:0.5] CGColor];   //设置弹出框边框颜色
        self.autoresizesSubviews = YES;
        imageView = [[ImageCropper alloc] initWithImage:UIimage];
        
        [self addSubview:imageView.view];
        
        UIButton *closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
        //closeBt.frame = CGRectMake(20, 20, 280, 20);
        CGSize result = frame.size;
        int width = result.width-30;
        
        [closeBt setFrame:CGRectMake(width, -10, 40, 40)];
        
        //设置button标题
        [closeBt setTitle:@"关闭1" forState:UIControlStateNormal];
        [closeBt setImage:[UIImage imageNamed:@"hotspots10"] forState:UIControlStateNormal];
        [closeBt addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
        closeBt.tag = 1;
        
        [self addSubview:closeBt];
        
    }
    return self;
}
-(void) setImage:(UIImage *) image{
    self.UIimage = image;
}


-(IBAction)onClickButton:(id)sender{
    //self.removeFromSuperview;
    [self removeFromSuperview];
}
- (void)dealloc {
    [super dealloc];
}

@end
