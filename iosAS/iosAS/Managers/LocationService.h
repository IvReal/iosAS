//  LocationService.h
//  iosAS
//  Created by Iv on 23/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

NS_ASSUME_NONNULL_BEGIN

@class City;
@class CLLocation;

@interface LocationService : NSObject

+ (LocationService*) shared;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;

- (void) requestCurrentLocation;
- (nullable City*) cityByLocation: (NSArray<City*>*) cities location:(CLLocation *)location;
- (nullable City*) cityByCurrentLocation: (NSArray<City*>*) cities;

@end

NS_ASSUME_NONNULL_END
