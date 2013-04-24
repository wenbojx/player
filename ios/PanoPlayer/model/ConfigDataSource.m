//
//  ConfigDataSource.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-20.
//
//

#import "ConfigDataSource.h"

@implementation ConfigDataSource

-(NSDictionary *)getUserInfo{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];
    
    //读文件
    NSDictionary* userInfo = [NSDictionary dictionaryWithContentsOfFile:filename];
    
    return userInfo;
}

-(id)init{
    self = [super init];
    if (self){
        
    }
    return self;
}

-(int)getMid{
    NSDictionary *userInfo = [self getUserInfo];
    int mid = 1;
    if (userInfo != nil) {
        mid = [[userInfo objectForKey:@"mid"] intValue];
        if (mid == 0) {
            mid = 1;
        }
    }
    //NSLog(@"mid=%d", mid);
    return mid;
}
-(NSString *)getUsername{
    NSDictionary *userInfo = [self getUserInfo];
    NSString *username = @"yiluhao";
    if (userInfo != nil) {
        username = [userInfo objectForKey:@"userName"];
        if (username == 0 || username ==nil || [username isEqualToString:@""]) {
            username = @"yiluhao";
        }
    }
    
    //NSLog(@"username=%@", username);
    return username;
}
-(int)getConfigCache{
    NSDictionary *userInfo = [self getUserInfo];
    int configCache = 90;
    if (userInfo != nil) {
        configCache = [[userInfo objectForKey:@"configCacheValue"] intValue];
        if (configCache == 0) {
            configCache = 90;
        }
    }

    //NSLog(@"configCache=%d", configCache);
    return configCache;
}
-(int)getDatasCache{
    NSDictionary *userInfo = [self getUserInfo];
    int dataCache = 360;
    if (userInfo != nil) {
        dataCache = [[userInfo objectForKey:@"datasCacheValue"] intValue];
        if (dataCache == 0) {
            dataCache = 360;
        }
    }
    //NSLog(@"dataCache=%d", dataCache);
    return dataCache;
}
-(int)getPlayerRotate{
    NSDictionary *userInfo = [self getUserInfo];
    int playerRotate = 150;
    if (userInfo != nil) {
        playerRotate = [[userInfo objectForKey:@"playerRotateValue"] intValue];
        if (playerRotate == 0) {
            playerRotate = 150;
        }
    }
    //NSLog(@"playerRotate=%d", playerRotate);
    return playerRotate;
}
-(Boolean)getPlayeRsensoria{
    NSDictionary *userInfo = [self getUserInfo];
    Boolean playeRsensorial = false;
    if (userInfo != nil) {
        playeRsensorial = [[userInfo objectForKey:@"playeRsensorialValue"] boolValue];
    }
    //NSLog(@"playeRsensorial=%d", playeRsensorial);
    return playeRsensorial;
}

@end
