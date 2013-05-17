//
//  Tools.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-17.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

-(NSString *)getFileSavePath:(NSString *)fileName;
-(void)SaveStringToFile:(NSString *)filePath content:(NSString *)content;
-(void)AppendStringToFile:(NSString *)filePath content:(NSString *)content;


@end
