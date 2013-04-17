//
//  MessView.h
//  AOWaterView
//
//

#import <UIKit/UIKit.h>
#import "DataInfo.h"

@protocol imageDelegate <NSObject>

-(void)click:(DataInfo *)data;

@end

@interface MessView : UIView
@property(nonatomic,strong)DataInfo *dataInfo;
@property(nonatomic,strong)id<imageDelegate> idelegate;

-(id)initWithData:(DataInfo *)data yPoint:(float) y;

-(void)click;
@end
