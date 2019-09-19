//  City.m
//  iosAS
//  Created by Iv on 18/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "City.h"

@interface City ()

@property (nonatomic, strong, nonnull, readwrite) NSString* code;
@property (nonatomic, strong, nonnull, readwrite) NSString* name;
@property (nonatomic, strong, nonnull, readwrite) NSString* timeZone;
@property (nonatomic, strong, nonnull, readwrite) NSString* countryCode;
@property (nonatomic, strong, nonnull, readwrite) NSDictionary* translations;
@property (nonatomic, strong, nonnull, readwrite) NSNumber* lon;
@property (nonatomic, strong, nonnull, readwrite) NSNumber* lat;

@end

@implementation City

+ (nullable City*) createWithDictionary: (NSDictionary*) dictionary {
    if (NO == [dictionary isKindOfClass: [NSDictionary class]]) { return nil; }
    NSString* name = [dictionary objectForKey: @"name"];
    if (NO == [name isKindOfClass: [NSString class]]) { return nil; }
    NSString* code = [dictionary objectForKey: @"code"];
    if (NO == [code isKindOfClass: [NSString class]]) { return nil; }
    NSDictionary* translations = [dictionary objectForKey: @"name_translations"];
    if (NO == [translations isKindOfClass: [NSDictionary class]]) { return nil; }
    NSDictionary* coordinates = [dictionary objectForKey: @"coordinates"];
    if (NO == [coordinates isKindOfClass: [NSDictionary class]]) { return nil; }
    NSNumber* lon = [coordinates objectForKey: @"lon"];
    if (NO == [lon isKindOfClass: [NSNumber class]]) { return nil; }
    NSNumber* lat = [coordinates objectForKey: @"lat"];
    if (NO == [lat isKindOfClass: [NSNumber class]]) { return nil; }
    NSString* timeZone = [dictionary objectForKey: @"time_zone"];
    if (NO == [timeZone isKindOfClass: [NSString class]]) { return nil; }
    NSString* countryCode = [dictionary objectForKey: @"country_code"];
    if (NO == [countryCode isKindOfClass: [NSString class]]) { return nil; }
    
    City* city = [City new];
    city.name = name;
    city.code = code;
    city.timeZone = timeZone;
    city.countryCode = countryCode;
    city.lon = lon;
    city.lat = lat;
    city.translations = translations;

    return city;
}

- (NSString *)description {
    NSMutableString* description = [NSMutableString new];
    [description appendString: [super description]];
    [description appendFormat: @"\n name = %@", self.name];
    [description appendFormat: @"\n code = %@", self.code];
    [description appendFormat: @"\n lon = %@", self.lon];
    [description appendFormat: @"\n lat = %@", self.lat];
    [description appendFormat: @"\n timeZone = %@", self.timeZone];
    [description appendFormat: @"\n countryCode = %@", self.countryCode];
    [description appendFormat: @"\n translations = %@", self.translations];
    return description;
}

@end

