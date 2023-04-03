//
//  SimpleTodoAppApp.swift
//  SimpleTodoApp
//
//  Created by Belghit Haron on 2/4/2023.
//

import SwiftUI

@main
struct SimpleTodoAppApp: App {
    
    let persistanceContainer = CoreDataManager.shared.persistanceContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistanceContainer.viewContext)
        }
    }
}
