//
//  Grocery+CoreDataProperties.swift
//  Grocery
//
//  Created by Kegham Karsian on 10/19/16.
//  Copyright © 2016 appologi. All rights reserved.
//

import Foundation
import CoreData


extension Grocery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery");
    }

    @NSManaged public var item: String?
    @NSManaged public var isPurchased: Bool
    @NSManaged public var timeStamp: Double

}
