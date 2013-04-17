//
//  AOWaterView.h
//  AOWaterView
//
//

#import <UIKit/UIKit.h>
#import "MessView.h"

@interface AOWaterView : UIScrollView<imageDelegate>
{
    UIView *v1;// 第一列view
    UIView *v2;// 第二列view
    UIView *v3;// 第三列view
    int higher;//最高列
    int lower;//最低列
    float highValue;//最高列高度

    int row ;//行数
    BOOL _reloading;

    
  


}

//初始化view
-(id)initWithDataArray:(NSMutableArray *)array;
//刷新view
-(void)refreshView:(NSMutableArray *)array;
//获取下一页
-(void)getNextPage:(NSMutableArray *)array;
@end
