//  PlaceViewController.m
//  iosAS
//  Created by Iv on 18/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "PlaceViewController.h"
#import "PlaceTableCell.h"
#import "DataManager.h"

#define ReuseIdentifier @"CellIdentifier"

@interface PlaceViewController ()

@property (nonatomic) PlaceType placeType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *currentArray;

@end

@implementation PlaceViewController

- (instancetype)initWithType:(PlaceType)type
{
    self = [super init];
    if (self) {
        _placeType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
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
    _tableView.frame = self.view.bounds;
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
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = city.name;
        cell.detailTextLabel.text = city.code;
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        cell.textLabel.text = airport.name;
        cell.detailTextLabel.text = airport.code;
    }*/
    NSString* placeCellID = NSStringFromClass([PlaceTableCell class] );
    PlaceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellID];
    if (!cell) {
        cell = [[PlaceTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:placeCellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (_segmentedControl.selectedSegmentIndex == 0) {
        City *city = [_currentArray objectAtIndex:indexPath.row];
        [cell configureWithName:city.name andCode:city.code];
    }
    else if (_segmentedControl.selectedSegmentIndex == 1) {
        Airport *airport = [_currentArray objectAtIndex:indexPath.row];
        [cell configureWithName:airport.name andCode:airport.code];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataSourceType dataType = ((int)_segmentedControl.selectedSegmentIndex) + 1;
    [self.delegate selectPlace:[_currentArray objectAtIndex:indexPath.row] withType:_placeType andDataType:dataType];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
