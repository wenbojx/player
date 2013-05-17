//
//  GpsDatas.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-17.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tools.h"

@interface GpsDatas : NSObject{
    NSString *fileName;
    Tools *tools;
    NSString *filePath;
    NSString *content;
    int saveTime;//每隔几秒保存一次数据
}

-(void)SetFileName;

-(NSString *)GetFileName;

-(void)SaveDatas:(double)lat lng:(double)lng alti:(float)alti speed:(float)speed degree:(float)degree;
@end
