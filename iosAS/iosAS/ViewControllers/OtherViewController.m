//  OtherViewController.m
//  iosAS
//  Created by Iv on 26/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "OtherViewController.h"
#import "ColoredViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface OtherViewController ()

@property (nonatomic, weak, readwrite) UIButton* buttonRedVC;
@property (nonatomic, weak, readwrite) UIButton* buttonYellowVC;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Other";
    // Aquamarine #7FFFD4 127, 255, 212
    self.view.backgroundColor = [UIColor colorWithRed:127/255.0f green:255/255.0f blue:212/255.0f alpha:1.0];

    [self addRedButton];
    [self addYellowButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width  = self.view.frame.size.width;
    
    CGFloat x = 50.0;
    CGFloat y = 10.0;
    CGFloat w = width - x * 2;
    CGFloat indent = 10.0;
    CGFloat hButton = 50.0;
    
    self.buttonRedVC.frame = CGRectMake(x, y, w, hButton);
    y += self.buttonRedVC.frame.size.height + indent;
    self.buttonYellowVC.frame = CGRectMake(x, y, w, hButton);
}

#pragma mark - Buttons

- (void)addRedButton {
    if (nil != self.buttonRedVC) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"TEST CONTROLS 1" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    button.tintColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(redButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonRedVC = button;
}

- (void)addYellowButton {
    if (nil != self.buttonYellowVC) { return; }
    UIButton *button = [UIButton buttonWithType: UIButtonTypeSystem];
    [button setTitle:@"TEST CONTROLS 2" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    button.tintColor = [UIColor blueColor];
    [button addTarget:self action:@selector(yellowButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    self.buttonYellowVC = button;
}

- (void)redButtonTap:(UIButton *)sender
{
    Test1ViewController* vc = [Test1ViewController new];
    vc.caption = @"RedVC";
    vc.color = [UIColor redColor];
    [self.navigationController pushViewController: vc animated: YES];
}

- (void)yellowButtonTap:(UIButton *)sender
{
    Test2ViewController* vc = [Test2ViewController new];
    vc.caption = @"YellowVC";
    vc.color = [UIColor yellowColor];
    [self.navigationController pushViewController: vc animated: YES];
}

@end
