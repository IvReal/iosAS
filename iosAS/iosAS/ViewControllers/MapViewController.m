//  MapViewController.m
//  iosAS
//  Created by Iv on 23/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MapViewController.h"
#import "LocationService.h"
#import "DataManager.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) NSArray *cities;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Cities";
    
    _mapView = [MKMapView new];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _cities = [DataManager shared].cities;
    _locationService = [LocationService shared];
    [_locationService requestCurrentLocation];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
    
    [self reload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mapView.frame = self.view.bounds;
}

- (void)reload {
    CLLocation *currentLocation = [LocationService shared].currentLocation;
    if (nil != currentLocation) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
        [_mapView setRegion: region animated: YES];
        [_mapView removeAnnotations: _mapView.annotations];
        for (City *city in _cities) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
                annotation.title = [NSString stringWithFormat:@"%@", city.name];
                annotation.subtitle = [NSString stringWithFormat:@"%@ (%@)", city.countryCode, city.code];
                CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([city.lat doubleValue], [city.lon doubleValue]);
                annotation.coordinate = coord;
                [self.mapView addAnnotation: annotation];
            });
        }
    }
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    [self reload];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"MarkerIdentifier";
    MKMarkerAnnotationView *annotationView = (MKMarkerAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView) {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoLight];
    }
    annotationView.annotation = annotation;
    return annotationView;
}

@end
