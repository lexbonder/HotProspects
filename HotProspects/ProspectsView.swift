//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Alex Bonder on 9/21/23.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    let filter: FilterType
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        if prospect.isContacted {
                            Label("Contacted", systemImage: "person.crop.circle.badge.checkmark")
                                .foregroundStyle(.green)
                                .labelStyle(.iconOnly)
                                .font(.title)
                        } else {
                            Label("Not Contacted", systemImage: "person.crop.circle.badge.clock")
                                .foregroundStyle(.orange)
                                .labelStyle(.iconOnly)
                                .font(.title)
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            prospects.delete(prospect)
                        } label: {
                            Label("Delete Contact", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .contextMenu {
                Button {
                    prospects.setSortMethod(.date)
                } label: {
                    Text("Sort by Recent")
                }
                
                Button {
                    prospects.setSortMethod(.name)
                } label: {
                    Text("Sort by Name")
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Alex Bonder\nlexbonder@gmail.com", completion: handleScan)
            }
        }
    }
    
    var title: String{
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted People"
        case.uncontacted:
            return "Uncontacted People"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
        case .failure(let error):
            print("Scan Failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            // Build content of the reminder
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            
            // Control when trigger happens
            var dateComponents = DateComponents() // build a date components object
            dateComponents.hour = 9 // any 9:00 am
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // the next 9am, no repeats.
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // for testing, fire in 5 seconds.
            
            // Build finished request
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            // Add it to the notification center where it will be handled by iOS magic ✨
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Oh no! Permission request failed!")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
