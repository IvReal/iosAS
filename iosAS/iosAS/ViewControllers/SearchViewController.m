//  SearchViewController.m
//  iosAS
//  Created by Iv on 05/10/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "SearchViewController.h"
#import "TicketViewController.h"
#import "DataManager.h"
#import "MapPrice.h"
#import "City.h"
#import "APIManager.h"
#import "DataBaseManager.h"
#import "LocalNotificationManager.h"

#define TicketReuseIdentifier @"TicketCellIdentifier"

@interface SearchViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *currentArray;
@property (nonatomic, strong) APIManager *apiManager;

@property (nonatomic, weak) NSString* codeFrom;
@property (nonatomic, weak) NSString* codeTo;
@property (nonatomic, weak) MapPrice* currentPrice;

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *dateTextField;


@end

@implementation SearchViewController

- (instancetype)initWithFrom:(NSString*)from andTo:(NSString*)to {
    self = [super init];
    if (self) {
        _codeFrom = from;
        _codeTo = to;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Tickets";
    // Plum #DDA0DD 221, 160, 221
    self.view.backgroundColor = [UIColor colorWithRed:221/255.0f green:160/255.0f blue:221/255.0f alpha:1.0];

    _apiManager = [APIManager shared];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];

    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];

    [self reloadPrices];
}

- (void)viewWillAppear:(BOOL)animated {
    //[self reloadPrices];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

- (void)reloadPrices {
    __weak typeof(self) weakSelf = self;
    /*[self.apiManager getMapPricesFrom: self.codeFrom to: self.codeTo completion:^(NSArray<MapPrice *> * _Nonnull prices) {
        weakSelf.currentArray = prices;
        [weakSelf.tableView reloadData];
    }];*/
    [self.apiManager getMapPricesFrom:self.codeFrom completion:^(NSArray<MapPrice *> * _Nonnull prices) {
        NSMutableArray *arr = [NSMutableArray new];
        for (MapPrice* price in prices) {
            if ([price.destinationIATA isEqualToString:weakSelf.codeTo])
                [arr addObject:price];
        }
        weakSelf.currentArray = arr;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:TicketReuseIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    MapPrice *price = [_currentArray objectAtIndex:indexPath.row];
    if (price.originCity == nil && price.destinationCity == nil) {
        [price fillWithCities:[[DataManager shared] cities]];
    }
    // TODO: move to helper
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@ (%@-%@)", price.originCity.name, price.destinationCity.name, price.originIATA, price.destinationIATA];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Depart date: %@, Price: %ld RUR, %@", [dateFormatter stringFromDate:price.departDate], (long)price.value, price.gate];
    cell.backgroundColor = self.view.backgroundColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentPrice = [self.currentArray objectAtIndex:indexPath.row];
    if (NO == [self.currentPrice isKindOfClass:[MapPrice class]]) { return; }
    NSString *title = [NSString stringWithFormat:@"%@\n%@",
                       [NSString stringWithFormat:@"%@-%@", self.currentPrice.originCity.name, self.currentPrice.destinationCity.name],
                       [NSString stringWithFormat:@"%ld RUR", (long)self.currentPrice.value]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:@"Что необходимо сделать?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([[DataBaseManager shared] isFavorite:self.currentPrice]) {
        favoriteAction = [UIAlertAction actionWithTitle:@"Удалить из избранного" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[DataBaseManager shared] removeMapPriceFromFavorite:self.currentPrice];
        }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@"Добавить в избранное" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[DataBaseManager shared] addMapPriceToFavorite:self.currentPrice];
        }];
    }
    UIAlertAction *notificationAction = [UIAlertAction actionWithTitle:@"Напомнить" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.dateTextField becomeFirstResponder];
    }];
    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"Открыть билет" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        TicketViewController *vc = [[TicketViewController alloc] initWithObject:self.currentPrice];
        [self.navigationController pushViewController: vc animated: YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:openAction];
    [alertController addAction:favoriteAction];
    if (notificationAction != nil) { [alertController addAction:notificationAction]; }
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender
{
    if (_datePicker.date && self.currentPrice) {
        [[DataBaseManager shared] addMapPriceToFavorite:self.currentPrice];

        NSString *message = [NSString stringWithFormat:@"%@-%@, %ld RUR", self.currentPrice.originCity.name, self.currentPrice.destinationCity.name, (long)self.currentPrice.value];
        NSString *ident = [NSString stringWithFormat:@"%@-%@", self.currentPrice.originIATA, self.currentPrice.destinationIATA];

        [[LocalNotificationManager shared] send:message at: _datePicker.date id:ident];
    }
    _datePicker.date = [NSDate date];
    self.currentPrice = nil;
    [self.view endEditing:YES];
}

@end
