//
//  SettingPlaceCell.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-18.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "SettingPlaceCell.h"

@implementation SettingPlaceCell

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect origFrame = self.contentView.frame;
	if (self.textField.text != nil || self.textField.placeholder != nil) {
        self.textField.hidden = NO;
        self.textField.frame = CGRectMake(origFrame.origin.x, origFrame.origin.y, origFrame.size.width-20, origFrame.size.height-1);
        
	} else {
		self.textField.hidden = YES;
		NSInteger imageWidth = 0;
		if (self.imageView.image != nil) {
			imageWidth = self.imageView.image.size.width + 5;
		}
		self.textField.frame = CGRectMake(origFrame.origin.x+imageWidth+10, origFrame.origin.y, origFrame.size.width-imageWidth-20, origFrame.size.height-1);
	}
    
    [self setNeedsDisplay];
}


@end
