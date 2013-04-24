//
//  ConfigDataSource.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-20.
//
//

#import <Foundation/Foundation.h>

@interface ConfigDataSource : NSObject{
    //NSDictionary *userInfo;
}

-(int)getMid;
-(NSString *)getUsername;
-(int)getConfigCache;
-(int)getDatasCache;
-(int)getPlayerRotate;
-(Boolean)getPlayeRsensoria;
@end
