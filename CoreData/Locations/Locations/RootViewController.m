//
//  RootViewController.m
//  Locations
//
//  Created by 石井賢二 on 2014/08/24.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

#import "RootViewController.h"
#import "Event.h"

@implementation RootViewController

@synthesize eventsArray;
@synthesize managedObjectContext;
@synthesize addButton;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    
    //タイトルを設定する。
    self.title = @"Locations";
    // ボタンをセットアップする。
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    // 初期状態ではfalse
    addButton.enabled = NO;
    // ナビゲータの右に配置
    self.navigationItem.rightBarButtonItem = addButton;
    // ロケーションマネージャを起動する。
    NSLog(@"startUpdatingLocation");
    [[self locationManager] startUpdatingLocation];
    
    // テーブルに表示する用の配列の初期化
    eventsArray = [[NSMutableArray alloc] init];
    
    // 格納したデータのフェッチ
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        // エラーを処理する。
    }
    [self setEventsArray:mutableFetchResults];
}

// ViewのUnload処理
- (void)viewDidUnload {
    self.eventsArray = nil;
    self.locationManager = nil;
    self.addButton = nil;
}

// Core Location 生成 (locationManagerのgetter)
- (CLLocationManager *)locationManager {
    NSLog(@"locationManager");
    if (locationManager != nil) {
        return locationManager;
    }
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.delegate = self;
    return locationManager;
}

// Addボタン押下時の処理
- (void)addEvent {
    NSLog(@"addEvent");
    CLLocation *location = [locationManager location];
    if (!location) {
        return;
    }

    // Eventエンティティの新規インスタンスを作成して設定する
    Event *event = (Event *)[NSEntityDescription insertNewObjectForEntityForName:@"Event"
                                                          inManagedObjectContext:managedObjectContext];
    CLLocationCoordinate2D coordinate = [location coordinate];
    [event setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
    [event setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
    [event setCreationDate:[NSDate date]];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // エラーを処理する。
    }

    [eventsArray insertObject:event atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma tableview - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [eventsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"hoge0");

    // タイムスタンプ用の日付フォーマッタ
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    // 緯度と経度用の数値フォーマッタ
    static NSNumberFormatter *numberFormatter = nil;
    if (numberFormatter == nil) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numberFormatter setMaximumFractionDigits:3];
    }
    static NSString *CellIdentifier = @"Cell";
    // 新規セルをデキューまたは作成する
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Event *event = (Event *)[eventsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dateFormatter stringFromDate:[event creationDate]];
    NSString *string = [NSString stringWithFormat:@"%@, %@",
                        [numberFormatter stringFromNumber:[event latitude]],
                        [numberFormatter stringFromNumber:[event longitude]]];
    cell.detailTextLabel.text = string;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 指定のインデックスパスにある管理オブジェクトを削除する。
        NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
        [managedObjectContext deleteObject:eventToDelete];
        // 配列とTable Viewを更新する。
        [eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

#pragma CoreLocation - delegate Method

// ロケーションの更新時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    NSLog(@"update");
    addButton.enabled = YES;
}

// ロケーション取得失敗時に呼ばれる
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"fail");
    addButton.enabled = NO;
}

@end
