//
//  ContentView.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/15/23.
//

import SamplePackage
import SwiftUI

struct ContentView: View {
    let possibleNumbers = Array(1...60)
    
    var body: some View {
        VStack {
            Text(results)
        }
        .padding()
    }
    
    var results: String {
        let selected = possibleNumbers.random(7).sorted()
        let strings = selected.map(String.init)
        return strings.joined(separator: ", ")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
