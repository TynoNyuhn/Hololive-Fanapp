//
//  ContentView.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/23/21.
//

import SwiftUI
import CoreData

struct ViewAllComments: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        
            List {
                ForEach(items.reversed()) { item in
                    Text("\(item.character!)\n\(item.userName!)\n\(item.comment!)\n\(item.timestamp!, formatter: itemFormatter)")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            Text("Delete a comment")
        
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items.reversed()[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


struct ViewAllComments_Previews: PreviewProvider {
    static var previews: some View {
        ViewAllComments()
    }
}
