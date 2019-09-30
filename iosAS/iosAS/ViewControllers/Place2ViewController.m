//  Place2ViewController.m
//  iosAS
//  Created by Iv on 27/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "Place2ViewController.h"
#import "PlaceCollectionCell.h"
#import "DataManager.h"

@interface Place2ViewController () 

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) NSArray *searchArray;
@property (nonatomic, strong, readonly) NSArray *actualArray;

@end

@implementation Place2ViewController

- (instancetype)initWithType:(PlaceType)type
{
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

- (NSArray*) actualArray {
    if (nil != _searchController && [_searchController.searchBar.text length] > 0) {
        return _searchArray;
    }
    return _currentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.itemSize = CGSizeMake(200.0, 100.0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PlaceCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([PlaceCollectionCell class])];
    [self.view addSubview:_collectionView];

    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    _searchArray = [NSArray new];
    self.navigationItem.searchController = _searchController;

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Cities", @"Airports"]];
    [_segmentedControl addTarget:self action:@selector(changeSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blueColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];
    
    self.title = _placeType == PlaceTypeDeparture ? @"From" : @"To";
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _collectionView.frame = self.view.bounds;
}

- (void)changeSource
{
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = [[DataManager shared] cities];
            break;
        case 1:
            _currentArray = [[DataManager shared] airports];
            break;
        default:
            break;
    }
    [self.collectionView reloadData];
}

#pragma mark - CollectionView Delegate & DataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString* placeCellID = NSStringFromClass([PlaceCollectionCell class]);
    PlaceCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:placeCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[PlaceCollectionCell alloc] init];
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [self.actualArray objectAtIndex:indexPath.row];
        [cell configureWithName:city.name andCode:city.code];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [self.actualArray objectAtIndex:indexPath.row];
        [cell configureWithName:airport.name andCode:airport.code];
    }
    // Moccasin #FFE4B5 255, 228, 181
    cell.backgroundColor = [UIColor colorWithRed:255/255.0f green:228/255.0f blue:181/255.0f alpha:1.0];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actualArray.count;
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@ OR SELF.code CONTAINS[cd] %@", searchController.searchBar.text, searchController.searchBar.text];
        _searchArray = [_currentArray filteredArrayUsingPredicate: predicate];
        [_collectionView reloadData];
    }
}

@end
