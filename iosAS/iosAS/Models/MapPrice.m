//  MapPrice.m
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MapPrice.h"
#import "City.h"

@implementation MapPrice

+ (nullable MapPrice*) createWithDictionary: (NSDictionary*) dictionary {
    NSString* destinationIATA = [dictionary objectForKey: @"destination"];
    if (NO == [destinationIATA isKindOfClass: [NSString class]]) { destinationIATA = nil; }
    NSString* originIATA = [dictionary objectForKey: @"origin"];
    if (NO == [originIATA isKindOfClass: [NSString class]]) { originIATA = nil; }
    NSNumber* value = [dictionary objectForKey: @"value"];
    if (NO == [value isKindOfClass: [NSNumber class]]) { value = 0; }
    NSString* gate = [dictionary objectForKey: @"gate"];
    if (NO == [originIATA isKindOfClass: [NSString class]]) { gate = nil; }
    NSString* dateString = [dictionary objectForKey: @"depart_date"];
    NSDate* departureDate = nil;
    if (YES == [dateString isKindOfClass: [NSString class]]) {
        departureDate = [self dateFromString:dateString];
    }

    MapPrice* price = [MapPrice new];
    price.destinationIATA = destinationIATA;
    price.originIATA = originIATA;
    price.value = [value integerValue];
    price.gate = gate;
    price.departDate = departureDate;
    return price;
}

- (void) fillWithCities: (NSArray<City*>*) cities {
    for (City* city in cities) {
        if ([city.code isEqualToString: self.destinationIATA]) {
            self.destinationCity = city;
        }
        if ([city.code isEqualToString: self.originIATA]) {
            self.originCity = city;
        }
        if (self.originCity != nil && self.destinationCity != nil) { break; }
    }
}

+ (NSDate * _Nullable)dateFromString:(NSString *)dateString {
    if (!dateString) { return  nil; }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter dateFromString: dateString];
}

@end
