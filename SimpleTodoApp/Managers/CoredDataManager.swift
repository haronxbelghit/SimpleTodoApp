//
//  CoredDataManager.swift
//  SimpleTodoApp
//
//  Created by Belghit Haron on 2/4/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistanceContainer : NSPersistentContainer
    
    // basically creating a singleton
    static let shared: CoreDataManager = CoreDataManager()
    private init(){
        persistanceContainer = NSPersistentContainer(name: "SimpleTodoAppModel")
        persistanceContainer.loadPersistentStores { description, error in
            if let error = error {
                 fatalError("Error initializing core data: \(error)")
            }
        }
    }
}
