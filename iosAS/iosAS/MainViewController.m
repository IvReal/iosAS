//  ViewController.m
//  iosAS
//  Created by Iv on 15/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MainViewController.h"
#import "ColoredViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"
#import "NewsViewController.h"
#import "DataManager.h"
#import "APIManager.h"
#import "PlaceViewController.h"

@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic, weak, readwrite) UIBarButtonItem* buttonRedVC;
@property (nonatomic, weak, readwrite) UIBarButtonItem* buttonYellowVC;

@property (nonatomic, weak, readwrite) UIButton* buttonDeparture;
@property (nonatomic, weak, readwrite) UIButton* buttonArrival;
@property (nonatomic, weak, readwrite) UIButton* buttonSearch;
@property (nonatomic, weak, readwrite) UIButton* buttonNews;

@property (nonatomic, weak, readwrite) DataManager* dataManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.prefersLargeTitles = YES;
    [self setTitle: @"Main"];
    self.view.backgroundColor = [UIColor colorWithRed:0.0 green:255.0 blue:255.0 alpha:1.0];   //[UIColor blueColor];
    
    if (nil == self.buttonRedVC) {
        UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle: @"RedVC"
                                                                       style: UIBarButtonItemStyleDone
                                                                       target: self
                                                                       action: @selector(GoToRedVC)];
        self.navigationItem.rightBarButtonItem = btn;
        self.buttonRedVC = btn;
    }
    if (nil == self.buttonYellowVC) {
        UIBarButtonItem* btn = [[UIBarButtonItem alloc] initWithTitle: @"YellowVC"
                                                                       style: UIBarButtonItemStyleDone
                                                                       target: self
                                                                       action: @selector(GoToYellowVC)];
        self.navigationItem.leftBarButtonItem = btn;
        self.buttonYellowVC = btn;
    }
    
    [self addDepartureButton];
    [self addArrivalButton];
    [self addNewsButton];

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
    CGFloat height  = self.view.frame.size.height;

    CGFloat x = 50.0;
    CGFloat y = 10.0;
    CGFloat w = width - x * 2;
    CGFloat indent = 10.0;
    CGFloat hButton = 50.0;
    
    self.buttonDeparture.frame = CGRectMake(x, y, w, hButton);
    y += self.buttonDeparture.frame.size.height + indent;
    self.buttonArrival.frame = CGRectMake(x, y, w, hButton);
    self.buttonNews.frame = CGRectMake(x, height - indent * 2 - hButton, w, hButton);
}

#pragma mark - Colored controllers

- (void) GoToRedVC {
    Test1ViewController* vc = [Test1ViewController new];
    vc.caption = @"RedVC";
    vc.color = [UIColor redColor];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void) GoToYellowVC {
    Test2ViewController* vc = [Test2ViewController new];
    vc.caption = @"YellowVC";
    vc.color = [UIColor yellowColor];
    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - Buttons

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

- (void)addNewsButton {
    if (nil != self.buttonNews) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"BREAKING NEWS" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(newsButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonNews = button;
}

- (void)fromtoButtonTap:(UIButton *)sender
{
    PlaceViewController *placeViewController;
    if ([sender isEqual:self.buttonDeparture]) {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeDeparture];
    } else {
        placeViewController = [[PlaceViewController alloc] initWithType: PlaceTypeArrival];
    }
    placeViewController.delegate = self;
    [self.navigationController pushViewController: placeViewController animated:YES];
}

- (void)newsButtonTap:(UIButton *)sender
{
    NewsViewController *newsVC = [NewsViewController new];
    [self.navigationController pushViewController: newsVC animated:YES];
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
}

- (void) didReceiveCountries {
    NSLog(@"didReceiveCountries %lu", (unsigned long)self.dataManager.countries.count);
}

- (void) didReceiveCities {
    NSLog(@"didReceiveCities %lu", self.dataManager.cities.count);
}

- (void) didReceiveAirports {
    NSLog(@"didReceiveAirports %lu", self.dataManager.airports.count);
}

#pragma mark - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceType)placeType andDataType:(DataSourceType)dataType {
}

@end
