//  NewsItemViewController.m
//  iosAS
//  Created by Iv on 21/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "NewsItemViewController.h"
#import "NewsItem.h"

@interface NewsItemViewController ()

@property (nonatomic, weak) NewsItem *item;
@property (nonatomic, weak, readwrite) UILabel* labelAllNewsItem;

@end

@implementation NewsItemViewController

- (instancetype)initWithObject:(NewsItem*)object
{
    self = [super init];
    if (self) {
        self.item = object;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"News";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addLabel];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *allNewsItemText = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n%@\n\n%@",
                             [dateFormatter stringFromDate:self.item.publishedAt],
                             self.item.author,
                             self.item.title,
                             self.item.descr,
                             self.item.url];
    self.labelAllNewsItem.text = allNewsItemText;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat indent = 10;
    self.labelAllNewsItem.frame = CGRectMake(indent, indent, self.view.bounds.size.width - indent*2, self.view.bounds.size.height - indent*2);
    [self.labelAllNewsItem sizeToFit];
}

- (void)addLabel {
    if (nil != self.labelAllNewsItem) { return; }
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:20.0 weight: UIFontWeightRegular];
    label.textColor = [UIColor darkGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview: label];
    self.labelAllNewsItem = label;
}

@end
