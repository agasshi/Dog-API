//
//  Breed+CoreDataProperties.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//
//

import Foundation
import CoreData


extension Breed {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Breed> {
        return NSFetchRequest<Breed>(entityName: "Breed")
    }

    @NSManaged public var name: String?
    @NSManaged public var children: Set<Breed>?
    @NSManaged public var images: Set<Image>?

}

// MARK: Generated accessors for children
extension Breed {

    @objc(addChildrenObject:)
    @NSManaged public func addToChildren(_ value: Breed)

    @objc(removeChildrenObject:)
    @NSManaged public func removeFromChildren(_ value: Breed)

    @objc(addChildren:)
    @NSManaged public func addToChildren(_ values: Set<Breed>)

    @objc(removeChildren:)
    @NSManaged public func removeFromChildren(_ values: Set<Breed>)

}

// MARK: Generated accessors for images
extension Breed {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: Image)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: Image)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: Set<Image>)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: Set<Image>)

}

extension Breed : Identifiable {

}
