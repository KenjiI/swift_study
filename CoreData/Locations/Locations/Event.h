//
//  Event.h
//  Locations
//
//  Created by 石井賢二 on 2014/08/24.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;

@end
