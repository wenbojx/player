//
//  MyMapAnnotation.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "MyMapAnnotation.h"
@implementation MyMapAnnotation


@synthesize title2 = _title2;
@synthesize subtitle2 = _subtitle2;
@synthesize coordinate = _coordinate;
-(id)initWithTitle:(NSString *)title SubTitle:(NSString *)subtitle Coordinate:(CLLocationCoordinate2D)coordinate{
    if (self = [super init]) {
        self.title2 = title;
        self.subtitle2 = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}
- (NSString *)title{
    return _title2;
}
-(NSString *)subtitle{
    return _subtitle2;
}
-(CLLocationCoordinate2D)coordinate{
    return _coordinate;
}

@end
