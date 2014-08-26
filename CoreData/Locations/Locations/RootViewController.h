//
//  RootViewController.h
//  Locations
//
//  Created by 石井賢二 on 2014/08/24.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate>
{
    NSMutableArray *eventsArray;
    NSManagedObjectContext *managedObjectContext;
    CLLocationManager *locationManager;
    UIBarButtonItem *addButton;
}

@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) UIBarButtonItem *addButton;

- (void)addEvent;

@end
