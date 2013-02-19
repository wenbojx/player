//
//  HomeTableCellControllerCell.h
//  PanoPlayer
//
//  Created by 李文博 on 13-1-18.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableCellControllerCell : UITableViewCell{
    IBOutlet UIImageView *thumbImage;
    IBOutlet UILabel *panoTitle;
    IBOutlet UILabel *photoTime;
}
@property(retain, nonatomic) IBOutlet UIImageView *thumbImage;
@property(retain, nonatomic) IBOutlet UILabel *panoTitle;
@property(retain, nonatomic) IBOutlet UILabel *photoTime;

@end 
