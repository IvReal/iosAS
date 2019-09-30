//  ViewController.m
//  iosAS
//  Created by Iv on 15/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "PlaceViewController.h"
#import "Place2ViewController.h"
#import "LocationService.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak, readwrite) UIButton* buttonDeparture;
@property (nonatomic, weak, readwrite) UIButton* buttonArrival;
@property (nonatomic, weak, readwrite) UIButton* buttonSearch;
@property (nonatomic, weak, readwrite) UILabel* labelAddress;

@property (nonatomic, weak, readwrite) DataManager* dataManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle: @"Search"];
    // PowderBlue #B0E0E6  176, 224, 230
    self.view.backgroundColor = [UIColor colorWithRed:176/255.0f green:224/255.0f blue:230/255.0f alpha:1.0];
    
    [self addDepartureButton];
    [self addArrivalButton];
    [self addAddressLabel];

    self.dataManager = [DataManager shared];
    [self.dataManager loadData];

    [self addNotifications];
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width  = self.view.frame.size.width;
    //CGFloat height  = self.view.frame.size.height;

    CGFloat x = 50.0;
    CGFloat y = 10.0;
    CGFloat w = width - x * 2;
    CGFloat indent = 10.0;
    CGFloat hButton = 50.0;
    
    self.buttonDeparture.frame = CGRectMake(x, y, w, hButton);
    y += self.buttonDeparture.frame.size.height + indent;
    self.buttonArrival.frame = CGRectMake(x, y, w, hButton);
    y += self.buttonArrival.frame.size.height + indent;
    self.labelAddress.frame = CGRectMake(x, y, w, 100.0);
}

#pragma mark - Controls

- (void)addDepartureButton {
    if (nil != self.buttonDeparture) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"DEPARTURE FROM" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(fromtoButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonDeparture = button;
}

- (void)addArrivalButton {
    if (nil != self.buttonArrival) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"ARRIVAL TO" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(fromtoButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonArrival = button;
}

- (void)fromtoButtonTap:(UIButton *)sender
{
    if ([sender isEqual:self.buttonDeparture]) {
        PlaceViewController *placeViewController;
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
        placeViewController.delegate = self;
        [self.navigationController pushViewController: placeViewController animated:YES];
    } else {
        Place2ViewController *placeViewController;
        placeViewController = [[Place2ViewController alloc] initWithType: PlaceTypeArrival];
        //placeViewController.delegate = self;
        [self.navigationController pushViewController: placeViewController animated:YES];
    }
}

- (void)addAddressLabel {
    if (nil != self.labelAddress) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    [self.view addSubview:label];
    self.labelAddress = label;
}

#pragma mark - Notifications

- (void) addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveCountries)
                                                 name: [self.dataManager didLoadCountriesNotificationName]
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveCities)
                                                 name: [self.dataManager didLoadCitiesNotificationName]
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(didReceiveAirports)
                                                 name: [self.dataManager didLoadAirportsNotificationName]
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(updateCurrentLocation:)
                                                 name: kLocationServiceDidUpdateCurrentLocation
                                               object: nil];
}

- (void) removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: [self.dataManager didLoadCountriesNotificationName]
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: [self.dataManager didLoadCitiesNotificationName]
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: [self.dataManager didLoadAirportsNotificationName]
                                                  object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: kLocationServiceDidUpdateCurrentLocation
                                                  object: nil];
}

- (void) didReceiveCountries {
    NSLog(@"didReceiveCountries %lu", (unsigned long)self.dataManager.countries.count);
}

- (void) didReceiveCities {
    NSLog(@"didReceiveCities %lu", self.dataManager.cities.count);
    [[LocationService shared] requestCurrentLocation];
}

- (void) didReceiveAirports {
    NSLog(@"didReceiveAirports %lu", self.dataManager.airports.count);
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;
    City *city = [[LocationService shared] cityByLocation: [DataManager shared].cities location:currentLocation];
    if (NO == [city isKindOfClass:[City class]]) return;
    [self.buttonDeparture setTitle:[city.name uppercaseString] forState:UIControlStateNormal];
    [self addressFromLocation:currentLocation];
}

- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if ([placemarks count] > 0) {
            NSMutableString *address = [[NSMutableString alloc] initWithString:@"Your location is\n"];
            for (MKPlacemark *placemark in placemarks) {
                [address appendString:placemark.name];
            }
            /*
             UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Your location address" message:address preferredStyle: UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Close" style:(UIAlertActionStyleDefault) handler:nil]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
             */
            self.labelAddress.text = address;
        }
    }];
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
}

@end
