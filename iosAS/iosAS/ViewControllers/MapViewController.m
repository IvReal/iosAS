//  MapViewController.m
//  iosAS
//  Created by Iv on 23/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MapViewController.h"
#import "LocationService.h"
#import "DataManager.h"
#import "DataBaseManager.h"
#import "APIManager.h"
#import "MapPrice.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) LocationService *locationService;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) NSArray *cities;
@property (nonatomic, strong) NSArray *prices;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Map";
    
    _mapView = [MKMapView new];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _cities = [DataManager shared].cities;
    _locationService = [LocationService shared];
    [_locationService requestCurrentLocation];
    _apiManager = [APIManager shared];

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
    _prices = nil;
    CLLocation *currentLocation = [LocationService shared].currentLocation;
    if (nil != currentLocation) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
        [_mapView setRegion: region animated: YES];
        [_mapView removeAnnotations: _mapView.annotations];
        City *curCity = [self.locationService cityByCurrentLocation:self.cities];
        if (nil != curCity) {
            __weak typeof(self) weakSelf = self;
            [self.apiManager getMapPricesFrom: curCity.code completion:^(NSArray<MapPrice *> * _Nonnull prices) {
                [weakSelf reloadWith: prices];
            }];
        }
    }
}

- (void) reloadWith: (NSArray<MapPrice*>*) mapPrices {
    _prices = mapPrices;
    for (MapPrice* price in mapPrices) {
        [price fillWithCities:self.cities];
        City* city =  price.destinationCity;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([city.lat doubleValue], [city.lon doubleValue]);
        //if(MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(coordinate))) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ %ld RUR", city.name, (long)price.value];
            annotation.subtitle = [NSString stringWithFormat:@"%@-%@", price.originIATA, price.destinationIATA];
            annotation.coordinate = coordinate;
            [self.mapView addAnnotation: annotation];
        //}
    }}

- (void)updateCurrentLocation:(NSNotification *)notification {
    [self reload];
}

#pragma mark - MKMapViewDelegate

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

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSString *originDest = view.annotation.subtitle;
    MapPrice* curPrice = nil;
    if (_prices != nil) {
        for (MapPrice* price in _prices) {
            if ([originDest isEqualToString:[NSString stringWithFormat:@"%@-%@", price.originIATA, price.destinationIATA]]) {
                curPrice = price;
                break;
            }
        }
    }
    if (curPrice != nil) {
        NSString *title = [NSString stringWithFormat:@"%@\n%@", view.annotation.title, view.annotation.subtitle];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Что необходимо сделать?" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *favoriteAction;
        if ([[DataBaseManager shared] isFavorite:curPrice]) {
            favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[DataBaseManager shared] removeMapPriceFromFavorite:curPrice];
            }];
        } else {
            favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[DataBaseManager shared] addMapPriceToFavorite:curPrice];
            }];
        }
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:favoriteAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

//- (void)mapViewDidChangeVisibleRegion:(MKMapView *)mapView {
//    [self reload];
//}

@end
