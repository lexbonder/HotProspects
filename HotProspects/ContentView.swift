//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/15/23.
//

import SwiftUI

@MainActor class DelayedUpdater: ObservableObject {
    // @Published var value = 0 // broadcasts that the change is happening.
    
    // Using this structure means we get to include side effects. We can add behavior before and after.
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var updater = DelayedUpdater()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Value is \(updater.value)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
