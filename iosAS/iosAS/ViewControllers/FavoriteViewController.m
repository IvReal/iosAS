//  FavoriteViewController.m
//  iosAS
//  Created by Iv on 01/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "FavoriteViewController.h"
#import "DataManager.h"
#import "DataBaseManager.h"
#import "MapPrice.h"
#import "City.h"

#define FavReuseIdentifier @"FavCellIdentifier"

@interface FavoriteViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Favorites";
    // Plum #DDA0DD 221, 160, 221
    self.view.backgroundColor = [UIColor colorWithRed:221/255.0f green:160/255.0f blue:221/255.0f alpha:1.0];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"By Date", @"By Price"]];
    [_segmentedControl addTarget:self action:@selector(changeSort) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadPrices];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)reloadPrices {
    PriceSort ps = _segmentedControl.selectedSegmentIndex == 0 ? PriceSortDate : PriceSortPrice;
    [[DataBaseManager shared] loadFavoriteMapPricesWithSort: ps completion:^(NSArray<MapPrice*>* prices) {
        self.currentArray = prices;
        [self.tableView reloadData];
    }];
}

- (void)changeSort
{
    [self reloadPrices];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FavReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:FavReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MapPrice *price = [_currentArray objectAtIndex:indexPath.row];
    if (price.originCity == nil && price.destinationCity == nil) {
        [price fillWithCities:[[DataManager shared] cities]];
    }
    // TODO: move to helper
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@ (%@-%@)", price.originCity.name, price.destinationCity.name, price.originIATA, price.destinationIATA];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Depart date: %@, Price: %ld RUR", [dateFormatter stringFromDate:price.departDate], (long)price.value];
    cell.backgroundColor = self.view.backgroundColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MapPrice *curPrice = [self.currentArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@-%@", curPrice.originCity.name, curPrice.destinationCity.name];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Что необходимо сделать?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[DataBaseManager shared] removeMapPriceFromFavorite:curPrice];
        [self reloadPrices];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
