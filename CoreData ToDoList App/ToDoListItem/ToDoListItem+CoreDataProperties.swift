//
//  ToDoListItem+CoreDataProperties.swift
//  CoreData ToDoList App
//
//  Created by Macbook Air 2017 on 12. 3. 2024..
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isDone: Bool

}

extension ToDoListItem : Identifiable {

}
