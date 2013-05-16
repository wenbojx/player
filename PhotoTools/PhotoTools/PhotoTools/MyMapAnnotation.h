//
//  MyMapAnnotation.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyMapAnnotation : NSObject<MKAnnotation> {
    NSString * _title2;
    NSString *_subtitle2;
    CLLocationCoordinate2D _coordinate;
}
@property(nonatomic,retain)NSString* title2;
@property(nonatomic,retain)NSString* subtitle2;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate;

-(id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;

@end
