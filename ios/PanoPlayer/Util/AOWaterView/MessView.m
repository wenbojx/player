//
//  MessView.m
//  AOWaterView
//
//

#import "MessView.h"
//#import "UrlImageButton.h"
#import "UIButton+WebCache.h"
#define WIDTH 320/3
@implementation MessView
@synthesize idelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithData:(DataInfo *)data yPoint:(float) y{
   
    float imgW=data.width;//图片原宽度
    float imgH=data.height;//图片原高度
    float sImgW = WIDTH-4;//缩略图宽带
    float sImgH = sImgW*imgH/imgW;//缩略图高度
    self = [super initWithFrame:CGRectMake(0, y, WIDTH, sImgH+4)];
    if (self) {
        UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(2,2, sImgW, sImgH)];//初始化url图片按钮控件
        NSURL *url = [[NSURL alloc] initWithString:data.url];
        [imageBtn setImageWithURL: url];//设置图片地质
     
        [imageBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imageBtn];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(2, self.frame.size.height-22, WIDTH-4, 20)];
        label.backgroundColor = [UIColor blackColor];
        label.alpha=0.8;
        label.text=data.title;
        label.textColor =[UIColor whiteColor];
        [self addSubview:label];
       
    }
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)click{
    [self.idelegate click:self.dataInfo];
}
@end
