//
//  Image+CoreDataProperties.swift
//  Breed
//
//  Created by Stéphanie Sabine on 01/07/2022.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var url: String?

}

extension Image : Identifiable {

}
