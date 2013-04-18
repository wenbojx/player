//
//  MosaicModule.m
//  MosaicUI
//
//  Created by Ezequiel Becerra on 10/21/12.
//  Copyright (c) 2012 betzerra. All rights reserved.
//

#import "MosaicData.h"

@implementation MosaicData
@synthesize url, title, size, width, height, pid;

-(id)initWithDictionary:(NSDictionary *)aDict{
    self = [self init];
    if (self){
        self.pid = [aDict objectForKey:@"pid"];
        self.url = [aDict objectForKey:@"url"];
        self.size = [[aDict objectForKey:@"size"] integerValue];
        self.title = [aDict objectForKey:@"title"];
        self.width = [[aDict objectForKey:@"width"] intValue];
        self.height = [[aDict objectForKey:@"height"] intValue];
        
    }
    return self;
}

-(NSString *)description{
    NSString *retVal = [NSString stringWithFormat:@"%@ %@", [super description], self.title];
    return retVal;
}

@end
