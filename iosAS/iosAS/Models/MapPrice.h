//  MapPrice.h
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class City;

@interface MapPrice : NSObject

@property (nonatomic, strong) NSString* destinationIATA;
@property (nonatomic, strong) NSString* originIATA;
@property (nonatomic, strong) NSDate *departDate;
@property (nonatomic, assign) NSInteger value;
@property (nonatomic, strong) NSString* gate;

@property (nonatomic, strong) City* destinationCity;
@property (nonatomic, strong) City* originCity;

+ (nullable MapPrice*) createWithDictionary: (NSDictionary*) dictionary;

- (void) fillWithCities: (NSArray<City*>*) cities;

@end

NS_ASSUME_NONNULL_END
