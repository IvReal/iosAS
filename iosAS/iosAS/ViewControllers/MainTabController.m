//  MainTabController.m
//  iosAS
//  Created by Iv on 26/09/2019.
//  Copyright © 2019 Iv. All rights reserved.

#import "MainTabController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "NewsViewController.h"
#import "OtherViewController.h"
#import "FavoriteViewController.h"

@interface MainTabController ()

@end

@implementation MainTabController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName: nibNameOrNil bundle: nibBundleOrNil];
    [self initTabController];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    [self initTabController];
    return self;
}

- (void) initTabController {
    // search - navigation controller, table views, search
    UIViewController* mainViewController = [MainViewController new];
    UITabBarItem* tab1 = [[UITabBarItem alloc] initWithTitle: @"Search" image: nil tag: 0];
    UINavigationController* ncSearch = [[UINavigationController alloc] initWithRootViewController: mainViewController];
    //ncSearch.navigationBar.translucent = NO;
    ncSearch.navigationBar.prefersLargeTitles = YES;
    ncSearch.tabBarItem = tab1;

    // map - map, geolocation
    UIViewController* mapViewController = [MapViewController new];
    UITabBarItem* tab2 = [[UITabBarItem alloc] initWithTitle: @"Map" image: nil tag: 0];
    mapViewController.tabBarItem = tab2;

    // news - newsapi, table view
    UIViewController* newsViewController = [NewsViewController new];
    UITabBarItem* tab3 = [[UITabBarItem alloc] initWithTitle: @"News" image: nil tag: 0];
    UINavigationController* ncNews = [[UINavigationController alloc] initWithRootViewController: newsViewController];
    //ncNews.navigationBar.translucent = NO;
    ncNews.navigationBar.prefersLargeTitles = YES;
    ncNews.tabBarItem = tab3;

    // photos - collection view, image picker

    // favorites - table view
    UIViewController* favViewController = [FavoriteViewController new];
    UITabBarItem* tab4 = [[UITabBarItem alloc] initWithTitle: @"Favorites" image: nil tag: 0];
    UINavigationController* ncFav = [[UINavigationController alloc] initWithRootViewController: favViewController];
    //ncFav.navigationBar.translucent = NO;
    ncFav.navigationBar.prefersLargeTitles = YES;
    ncFav.tabBarItem = tab4;

    // other - other experiments
    UIViewController* otherViewController = [OtherViewController new];
    UITabBarItem* tab5 = [[UITabBarItem alloc] initWithTitle: @"Other" image: nil tag: 0];
    UINavigationController* ncOther = [[UINavigationController alloc] initWithRootViewController: otherViewController];
    ncOther.navigationBar.translucent = NO;
    ncOther.navigationBar.prefersLargeTitles = YES;
    ncOther.tabBarItem = tab5;

    self.viewControllers = @[ncSearch, mapViewController, ncNews, ncFav, ncOther];
}

@end
