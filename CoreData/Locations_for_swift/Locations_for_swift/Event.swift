//
//  File.swift
//  Locations_for_swift
//
//  Created by 石井賢二 on 2014/08/27.
//  Copyright (c) 2014年 石井賢二. All rights reserved.
//

import Foundation
import CoreData

@objc(Event)
class Event : NSManagedObject {

    @NSManaged var creationDate : NSDate
    @NSManaged var latitude : Double
    @NSManaged var longitude : Double
}
