//  LocationService.m
//  iosAS
//  Created by Iv on 23/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "LocationService.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LocationService () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong, readwrite) CLLocation *currentLocation;

@end

@implementation LocationService

+ (LocationService*) shared {
    static LocationService* shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (CLLocationManager *)locationManager {
    if (nil == _locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.distanceFilter = 1000;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void) requestCurrentLocation {
    [self.locationManager requestAlwaysAuthorization];
}

- (nullable City*) cityByCurrentLocation: (NSArray<City*>*) cities {
    return [self cityByLocation:cities location:self.currentLocation];
}

- (nullable City*) cityByLocation: (NSArray<City*>*) cities location:(CLLocation *)location {
    double minDistance = 10000;
    City* result = nil;
    for (City* city in cities) {
        CLLocation* cityLocation = [[CLLocation alloc] initWithLatitude: [city.lat doubleValue]
                                                              longitude: [city.lon doubleValue]];
        CLLocationDistance distance = [cityLocation distanceFromLocation: location];
        if (distance < minDistance) {
            result = city;
            minDistance = distance;
        }
    }
    return result;
}

- (void) postDidUpdatedCurrentLocation {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object: self.currentLocation];
    });
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self postDidUpdatedCurrentLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (nil == self.currentLocation) {
        self.currentLocation = [locations firstObject];
        [manager stopUpdatingLocation];
        [self postDidUpdatedCurrentLocation];
    }
}

@end
