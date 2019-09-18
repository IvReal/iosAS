//  Test1ViewController.m
//  iosAS
//  Created by Iv on 17/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "Test1ViewController.h"

@interface Test1ViewController ()

@property (nonatomic, weak, readwrite) UIView* viewExample;
@property (nonatomic, weak, readwrite) UILabel* labelExample;
@property (nonatomic, weak, readwrite) UITextField* textFieldExample;
@property (nonatomic, weak, readwrite) UITextView* textViewExample;
@property (nonatomic, weak, readwrite) UIImageView* imageViewExample;

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addView];
    [self addLabel];
    [self addTextField];
    [self addTextView];
    [self addImageView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat width  = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    CGFloat x = 50.0;
    CGFloat y = 100.0;
    CGFloat w = width - x * 2;
    CGFloat indent = 10.0;

    self.viewExample.frame = CGRectMake(x, y, w, 100.0);
    // labelExample inside viewExample
    self.labelExample.frame = CGRectMake(10.0, 10.0, self.viewExample.frame.size.width - 10.0, self.viewExample.frame.size.height - 10.0);
    y += self.viewExample.frame.size.height + indent;
    self.textFieldExample.frame = CGRectMake(x, y, w, 50.0);
    y += self.textFieldExample.frame.size.height + indent;
    self.textViewExample.frame = CGRectMake(x, y, w, 50.0);
    y += self.textViewExample.frame.size.height + indent;
    self.imageViewExample.frame = CGRectMake(x, y, w, height - y - indent);
}

- (void)addView {
    if (nil != self.viewExample) { return; }
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: view];
    self.viewExample = view;
}

- (void)addLabel {
    if (nil != self.labelExample) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:36.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"Label Example";
    [self.viewExample addSubview: label];
    self.labelExample = label;
}

- (void)addTextField {
    if (nil != self.textFieldExample) { return; }
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Text Field Example...";
    textField.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightLight];
    [self.view addSubview: textField];
    self.textFieldExample = textField;
}

-(void)addTextView {
    if (nil != self.textViewExample) { return; }
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor whiteColor];
    textView.textColor = [UIColor darkGrayColor];
    textView.text = @"Text View Example";
    [self.view addSubview:textView];
    self.textViewExample = textView;
}

-(void)addImageView {
    if (nil != self.imageViewExample) { return; }
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"4"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageView];
    self.imageViewExample = imageView;
}

@end
