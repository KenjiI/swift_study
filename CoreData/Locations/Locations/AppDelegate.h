//
//  AppDelegate.h
//  Locations
//
//  Created by 石井賢二 on 2014/08/24.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navigationController;
}
@property (nonatomic, retain) UINavigationController *navigationController;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
