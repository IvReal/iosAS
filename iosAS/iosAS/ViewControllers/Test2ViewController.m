//  Test2ViewController.m
//  iosAS
//  Created by Iv on 17/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "Test2ViewController.h"

@interface Test2ViewController ()

@property (nonatomic, weak, readwrite) UIButton* buttonExample;
@property (nonatomic, weak, readwrite) UISegmentedControl* segmentedControlExample;
@property (nonatomic, weak, readwrite) UISlider* sliderExample;
@property (nonatomic, weak, readwrite) UIActivityIndicatorView* activityIndicatorExample;
@property (nonatomic, weak, readwrite) UIProgressView* progressExample;

@end

@implementation Test2ViewController

- (nonnull NSString*) offTitle { return @"OFF Light"; }
- (nonnull NSString*) onTitle { return @"ON Light"; }

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButton];
    [self addSegmentedControl];
    [self addSlider];
    [self addActivityIndicator];
    [self addProgress];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width  = self.view.frame.size.width;
    //CGFloat height = self.view.frame.size.height;
    
    CGFloat x = 50.0;
    CGFloat y = 100.0;
    CGFloat w = width - x * 2;
    CGFloat indent = 10.0;

    self.buttonExample.frame = CGRectMake(x, y, w, 50.0);
    y += self.buttonExample.frame.size.height + indent;
    self.segmentedControlExample.frame = CGRectMake(x, y, w, 50.0);
    y += self.segmentedControlExample.frame.size.height + indent;
    self.sliderExample.frame = CGRectMake(x, y, w, 50.0);
    y += self.sliderExample.frame.size.height + indent;
    self.activityIndicatorExample.frame = CGRectMake(x, y, w, 100.0);
    y += self.activityIndicatorExample.frame.size.height + indent;
    self.progressExample.frame = CGRectMake(x, y, w, 100.0);
}

- (void)addButton {
    if (nil != self.buttonExample) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:self.offTitle forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blueColor];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(lightSwitchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonExample = button;
}

- (void)lightSwitchButtonDidTap:(UIButton *)sender
{
    UIColor* color = [self.view.backgroundColor isEqual: [UIColor yellowColor]] ? [UIColor blackColor] : [UIColor yellowColor];
    self.view.backgroundColor = color;
    NSString* title = [self.view.backgroundColor isEqual: [UIColor yellowColor]] ? self.offTitle : self.onTitle;
    [self.buttonExample setTitle:title forState: normal];
}

- (void)addSegmentedControl {
    if (nil != self.segmentedControlExample) { return; }
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Segmented", @"Control"]];
    segmentedControl.tintColor = [UIColor blueColor];
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:segmentedControl];
    self.segmentedControlExample = segmentedControl;
}

- (void)addSlider {
    if (nil != self.sliderExample) { return; }
    UISlider *slider = [[UISlider alloc] init];
    slider.tintColor = [UIColor blueColor];
    slider.value = 0.5;
    [self.view addSubview:slider];
    self.sliderExample = slider;
}

- (void)addActivityIndicator {
    if (nil != self.activityIndicatorExample) { return; }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.color = [UIColor blackColor];
    //activityIndicatorView.frame = self.view.bounds;
    activityIndicatorView.hidesWhenStopped = YES;
    [activityIndicatorView startAnimating];
    [self.view addSubview:activityIndicatorView];
    self.activityIndicatorExample = activityIndicatorView;
}

- (void)addProgress {
    if (nil != self.progressExample) { return; }
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle: UIProgressViewStyleDefault];
    progressView.progressTintColor = [UIColor blueColor];
    progressView.progress = 0.5;
    [self.view addSubview:progressView];
    self.progressExample = progressView;
}

@end
