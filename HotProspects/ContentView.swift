//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Text("Bug Hunter")
                .swipeActions {
                    Button(role: .destructive) {
                        print("Deleting")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("pinning")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
