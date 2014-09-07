//
//  Feed.swift
//  RssReader_1
//
//  Created by 石井賢二 on 2014/09/03.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import Foundation
import CoreData

@objc(Feed)
class Feed : NSManagedObject {
    
    @NSManaged var title : String
    @NSManaged var summary : String
    @NSManaged var link : String
    @NSManaged var receiveDate : NSDate
    @NSManaged var published : String
    
}
