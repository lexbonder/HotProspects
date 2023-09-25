//
//  Prospect.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/21/23.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var dateAdded = Date()
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    enum SortMethod {
        case date, name
    }
    
    @Published private(set) var people: [Prospect]
    let saveKey = "SavedData"
    let pathKey = "SavedData.json"
    var currentSortMethod = SortMethod.date {
        didSet {
            switch currentSortMethod {
            case .date:
                people.sort { lhs, rhs in
                    lhs.dateAdded > rhs.dateAdded
                }
            case .name:
                people.sort { lhs, rhs in
                    lhs.name < rhs.name
                }
            }
        }
    }
    let getDocumentsDirectory: () -> URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    init() {
        do {
            let url = getDocumentsDirectory().appendingPathComponent(pathKey, conformingTo: .json)
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Prospect].self, from: data)
            people = decoded
            return
        } catch {
            print("Read failed: \(error.localizedDescription)")
        }
        
        // this will happen if saved data is not found
        people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            let url = getDocumentsDirectory().appendingPathComponent(pathKey, conformingTo: .json)
            do {
                try encoded.write(to: url)
            } catch {
                print("Write failed: \(error.localizedDescription)")
            }
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func delete(_ prospect: Prospect) {
        people.removeAll { $0.id == prospect.id }
        save()
    }
    
    func setSortMethod(_ sortMethod: SortMethod) {
        switch sortMethod {
        case .date:
            currentSortMethod = .date
        case .name:
            currentSortMethod = .name
        }
    }
}
