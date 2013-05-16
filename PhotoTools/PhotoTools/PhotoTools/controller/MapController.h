//
//  MapController.h
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyMapAnnotation.h"


@interface MapController : UIViewController <MKMapViewDelegate>{
    MKMapView *mapView;
    MKPolyline * routeLine;
    MKPolylineView * routeLineView;
    NSMutableArray * allCoordinateArr;
    
}

@end
