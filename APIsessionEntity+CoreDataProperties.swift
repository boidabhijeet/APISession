//
//  APIsessionEntity+CoreDataProperties.swift
//  APIsession
//
//  Created by Abhi on 08/08/21.
//
//

import Foundation
import CoreData


extension APIsessionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<APIsessionEntity> {
        return NSFetchRequest<APIsessionEntity>(entityName: "APIsessionEntity")
    }

    @NSManaged public var summary: String?
    @NSManaged public var imName: String?
    @NSManaged public var imImage: String?
    @NSManaged public var imPrice: String?

}

extension APIsessionEntity : Identifiable {

}
