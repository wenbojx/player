//
//  MosaicModule.h
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MosaicData : NSObject{
    NSString *url;
    NSString *title;
    NSInteger size;
    float width;
    float height;
    NSString *pid;
}

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (strong) NSString *pid;
@property (strong) NSString *url;
@property (strong) NSString *title;
@property (readwrite) NSInteger size;
@property (readwrite) float width;
@property (readwrite) float height;

@end
