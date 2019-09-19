//  ViewController.m
//  iosAS
//  Created by Iv on 15/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MainViewController.h"
#import "ColoredViewController.h"
#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface MainViewController ()

@property (nonatomic, weak, readwrite) UIBarButtonItem* buttonRedVC;
@property (nonatomic, weak, readwrite) UIBarButtonItem* buttonYellowVC;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle: @"Blue VC"];
    self.view.backgroundColor = [UIColor blueColor];
    
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
}

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

@end
