//  ColoredViewController.m
//  iosAS
//  Created by Iv on 16/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "ColoredViewController.h"

@interface ColoredViewController ()

@end

@implementation ColoredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.color;
    [self setTitle:self.caption];
}

@end
