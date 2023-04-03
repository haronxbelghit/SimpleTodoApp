//
//  ContentView.swift
//  SimpleTodoApp
//
//  Created by Belghit Haron on 2/4/2023.
//

import SwiftUI

enum Priority: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    case Low, Medium, High
}

extension Priority {
    var title: String {
        switch self {
        case .Low:
            return "Low"
        case .Medium:
            return "Medium"
        case .High:
            return "High"
        }
    }
}

struct ContentView: View {
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .Medium
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)]) private var allTasks: FetchedResults<Task>
    
    private func saveTask() {
        do {
            let task = Task(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        switch (priority) {
        case .Low:
            return Color.green
        case .Medium:
            return Color.yellow
        case .High:
            return Color.red
        case .none:
            return Color.black
        }
    }
    
    private func updateTask(_ task: Task) {
        task.favorite = !task.favorite
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteTask(at offsets: IndexSet){
        offsets.forEach { index in
            let task = allTasks[index]
            viewContext.delete(task)
        }
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter task title", text: $title)
                .textFieldStyle(.roundedBorder)
                Picker("Select priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority in
                        Text(priority.title).tag(priority)
                    }
                }.pickerStyle(.segmented)
                Button("Save"){
                    saveTask()
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                )
                List {
                    ForEach(allTasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(task.priority!))
                                .frame(width: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.favorite ? "heart.fill" : "heart").foregroundColor(Color.red).onTapGesture {
                                updateTask(task)
                            }
                        }
                    }.onDelete(perform: deleteTask)
                }.background(Color.white)
                
                Spacer()
            }
            .padding()
            .navigationTitle("All Tasks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
