//
//  ProjectTableCell.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import <UIKit/UIKit.h>

@interface ProjectTableCell : UITableViewCell{
    IBOutlet UIImageView *thumbImage;
    IBOutlet UILabel *projectTitle;
    IBOutlet UILabel *photoTime;
    IBOutlet UIImageView *enter;
}

@property(retain, nonatomic)IBOutlet UIImageView *thumbImage;
@property(retain, nonatomic)IBOutlet UILabel *projectTitle;
@property(retain, nonatomic)IBOutlet UILabel *photoTime;
@property(retain, nonatomic)IBOutlet UIImageView *enter;

@end
