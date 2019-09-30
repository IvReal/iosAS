//  NewsViewController.m
//  iosAS
//  Created by Iv on 20/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "NewsViewController.h"
#import "NewsItemViewController.h"
#import "APIManager.h"
#import "NewsTableCell.h"
#import "NewsItem.h"

@interface NewsViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong, readwrite) APIManager* apiManager;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"ru", @"ua", @"de", @"gb", @"us"]];
    [_segmentedControl addTarget:self action:@selector(changeCountry) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    
    self.title = @"News";
    
    self.apiManager = [APIManager shared];
    [self changeCountry];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)changeCountry
{
    //_currentArray = [[DataManager shared] airports];
    __weak typeof(self) weakSelf = self;
    NSString *country = [self.segmentedControl titleForSegmentAtIndex:self.segmentedControl.selectedSegmentIndex];
    [self.apiManager getNewsForCountry:country completion:^(NSArray<NewsItem *> * _Nonnull news) {
        weakSelf.currentArray = news;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString* placeCellID = NSStringFromClass([NewsTableCell class] );
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellID];
    if (!cell) {
        cell = [[NewsTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellID];
    }
    NewsItem *item = [_currentArray objectAtIndex:indexPath.row];
    [cell configureWithTitle:item.title andAuthor:item.author andDate:item.publishedAt];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentArray == nil ? 0 : [_currentArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItem *item = [_currentArray objectAtIndex:indexPath.row];
    //NSLog(@"Row selected, object with title: %@", item.title);
    if (NO == [item isKindOfClass:[NewsItem class]]) { return; }
    NewsItemViewController *vc = [[NewsItemViewController alloc] initWithObject:item];
    [self.navigationController pushViewController: vc animated: YES];
}

@end
