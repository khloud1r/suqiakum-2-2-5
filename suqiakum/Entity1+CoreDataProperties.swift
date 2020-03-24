//
//  Entity1+CoreDataProperties.swift
//  
//
//  Created by Hany Karam on 3/8/20.
//
//

import Foundation
import CoreData


extension Entity1 {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity1> {
        return NSFetchRequest<Entity1>(entityName: "Entity1")
    }

    @NSManaged public var title: String?
    @NSManaged public var image: URL?
    @NSManaged public var number: Int16

}
