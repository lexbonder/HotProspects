//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    @State private var backgroundColor = Color.red
    
    var body: some View {
        VStack {
            Text("Hello, world!")
                .padding()
                .background(backgroundColor)
            
            Text("Change Color")
                .padding()
                .contextMenu {
                    Button {
                        backgroundColor = .red
                    } label: {
                        Label("Red", systemImage: "checkmark.circle.fill")
//                            .foregroundColor(.red) // foreground color is ignored - can add .destructive role to button, but like, why...
                    }
                    
                    Button("Blue") {
                        backgroundColor = .blue
                    }
                    
                    Button("Green") {
                        backgroundColor = .green
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
