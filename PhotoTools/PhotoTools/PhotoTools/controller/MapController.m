//
//  MapController.m
//  PhotoTools
//
//  Created by yiluhao on 13-5-16.
//  Copyright (c) 2013年 yiluhao. All rights reserved.
//

#import "MapController.h"

@interface MapController ()

@end

@implementation MapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapView=[[MKMapView alloc] initWithFrame:[self.view bounds]];
    mapView.delegate = self;
    //mapView.showsUserLocation=YES;
    mapView.zoomEnabled = YES;

    CLLocationCoordinate2D theCoordinate;

    //theCoordinate.latitude=31.19948054;
    //theCoordinate.longitude=121.51887075;
    
    theCoordinate.latitude=37.331799;
    theCoordinate.longitude=-122.030841;
    
    //设定显示范围
    MKCoordinateSpan theSpan;
    theSpan.latitudeDelta=0.01;
    theSpan.longitudeDelta=0.01;
    
    //设置地图显示的中心及范围
    MKCoordinateRegion theRegion;
    theRegion.center=theCoordinate;
    theRegion.span=theSpan;
    
    [mapView setRegion:theRegion];
    [mapView setScrollEnabled:YES];

    mapView.mapType = MKMapTypeStandard;
    //mapView.mapType = MKMapTypeSatellite;
    //mapView.mapType = MKMapTypeHybrid;

    //[mapView ]
    //[mapView setMapType:]
    [self.view addSubview:mapView];
    
    [self drawTestLine];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.954245, 116.312455);
    
    MyMapAnnotation *anno = [[MyMapAnnotation alloc]initWithTitle:@"title" SubTitle:@"subtitle" Coordinate:coordinate];
    [mapView addAnnotation:anno];
    
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(39.927871, 116.347683);
    
    anno = [[MyMapAnnotation alloc]initWithTitle:@"title" SubTitle:@"subtitle" Coordinate:coordinate2];
    
    [mapView addAnnotation:anno];
    [mapView removeAnnotation:anno];

    //[self map]
    
}


- (void)drawTestLine
{
    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.954245 longitude:116.312455];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:39.947871 longitude:116.327683];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:39.934245 longitude:116.332455];
    CLLocation *location3 = [[CLLocation alloc] initWithLatitude:39.927871 longitude:116.347683];
    
    //NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:location0];
    [array addObject:location1];
    [array addObject:location2];
    [array addObject:location3];
    
    
    [self drawLineWithLocationArray:array];
}

#pragma mark -

- (void)drawLineWithLocationArray:(NSMutableArray *)locationArray
{
    int pointCount = [locationArray count];
    CLLocationCoordinate2D *coordinateArray = (CLLocationCoordinate2D *)malloc(pointCount * sizeof(CLLocationCoordinate2D));
    
    for (int i = 0; i < pointCount; ++i) {
        CLLocation *location = [locationArray objectAtIndex:i];
        coordinateArray[i] = [location coordinate];
    }
    
    routeLine = [MKPolyline polylineWithCoordinates:coordinateArray count:pointCount];
    [mapView setVisibleMapRect:[routeLine boundingMapRect]];
    [mapView addOverlay:routeLine];
    
    free(coordinateArray);
    coordinateArray = NULL;
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    NSLog(@"aaaa");
    if(overlay == routeLine) {
        if(nil == routeLineView) {
            routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
            routeLineView.fillColor = [UIColor redColor];
            routeLineView.strokeColor = [UIColor redColor];
            routeLineView.lineWidth = 5;
        }
        return routeLineView;
    }
    return nil;
}
-(MKAnnotationView*)mapView:(MKMapView *)mapViewAnno viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[mapViewAnno.userLocation class]])
        return nil;
    
    MKPinAnnotationView *pinView = (MKPinAnnotationView*)[mapViewAnno dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    
    if (pinView ==nil)
        pinView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ID"];
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorPurple;//大头针的颜色
    pinView.animatesDrop = YES;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    view.backgroundColor = [UIColor redColor];
    
    pinView.leftCalloutAccessoryView = view;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = button;
    return pinView;
}


- (void)setCurrentLocation:(CLLocation *)location {
    MKCoordinateRegion region ;
    region.center = location.coordinate;
    region.span.longitudeDelta = 0.1f;
    region.span.latitudeDelta = 0.1f;

    [mapView setRegion:region animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
