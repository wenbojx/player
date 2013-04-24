//
//  ProjectTableCell.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import "ProjectTableCell.h"

@interface ProjectTableCell ()

@end

@implementation ProjectTableCell

@synthesize thumbImage;
@synthesize projectTitle;
@synthesize photoTime;
@synthesize enter;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
