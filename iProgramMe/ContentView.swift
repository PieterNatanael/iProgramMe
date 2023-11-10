//
//  ContentView.swift
//  iProgramMe
//
//  Created by Pieter Yoshua Natanael on 27/09/23.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notifications: [NotificationData] = []
    @State private var newText = ""
    @State private var selectedTime = Date()
    @State private var isShowingSplash = true
    
    var body: some View {
        NavigationStack {
            if isShowingSplash {
                SplashView(isShowingSplash: $isShowingSplash)
            } else {
                VStack {
                    List {
                        ForEach(notifications) { notification in
                            Text("\(notification.text) at \(formatTime(notification.notificationTime))")
                        }
                        .onDelete(perform: deleteNotification)
                    }
                    
                    HStack {
                        TextField("Enter text", text: $newText)
                        DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        Button(action: addNotification) {
                            Text("Add")
                        }
                    }
                }
                .navigationBarTitle("iProgramMe")
                .onAppear(perform: loadNotifications)
            }
        }
    }

    func addNotification() {
        if !newText.isEmpty && notifications.count < 10 {
            let newNotification = NotificationData(text: newText, notificationTime: selectedTime)
            notifications.append(newNotification)
            NotificationManager.scheduleNotification(notification: newNotification)
            newText = ""
            saveNotifications()
        }
    }

    func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
        saveNotifications()
    }

    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    func loadNotifications() {
        notifications = NotificationManager.loadNotifications()
    }

    func saveNotifications() {
        NotificationManager.saveNotifications(notifications: notifications)
    }
}

struct NotificationData: Identifiable, Codable {
    let id = UUID()
    let text: String
    let notificationTime: Date
}



#Preview {
ContentView()
}




/*

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notifications: [NotificationData] = []
    @State private var newText = ""
    @State private var selectedTime = Date()
    @State private var isShowingSplash = true // Added state for splash screen
    
    var body: some View {
        NavigationView {
            if isShowingSplash {
                SplashView(isShowingSplash: $isShowingSplash)
            } else {
               
                
                VStack {
                    
                    List {
                        ForEach(notifications) { notification in
                            Text("\(notification.text) at \(formatTime(notification.notificationTime))")
                        }
                        .onDelete(perform: deleteNotification)
                    }
                    
                    HStack {
                       
                        TextField("Enter text", text: $newText)
                        DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        
                        Button(action: addNotification) {
                            Text("Add")
                        }
                    }
                }
               
                .navigationBarTitle("iProgramMe")
               
            
                .onAppear(perform: loadNotifications)
                .onDisappear(perform: saveNotifications)
               
        }}}
    
    func addNotification() {
        if !newText.isEmpty && notifications.count < 10 {
            let newNotification = NotificationData(text: newText, notificationTime: selectedTime)
            notifications.append(newNotification)
            scheduleNotification(notification: newNotification) // Schedule the notification here
            newText = ""
        }
    }
    
    func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
        // Remove the corresponding scheduled notifications here
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func scheduleNotification(notification: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = "iProgramMe"
        content.body = notification.text

        // Configure the notification trigger based on the selected time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notification.notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create a unique identifier for the notification request
        let identifier = UUID().uuidString

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func loadNotifications() {
        // Load saved notifications here, e.g., from UserDefaults or a database
    }
    
    func saveNotifications() {
        // Save the notifications to persistent storage here
    }
}

struct NotificationData: Identifiable, Codable {
    let id = UUID()
    let text: String
    let notificationTime: Date
}




@available(iOS 15.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        return true
    }
}




*/

/*

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notifications: [NotificationData] = []
    @State private var newText = ""
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notifications) { notification in
                        Text("\(notification.text) at \(formatTime(notification.notificationTime))")
                    }
                    .onDelete(perform: deleteNotification)
                }
                
                HStack {
                    TextField("Enter text", text: $newText)
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    
                    Button(action: addNotification) {
                        Text("Add")
                    }
                }
            }
            .navigationBarTitle("iProgramMe")
        }
        .onAppear(perform: loadNotifications)
        .onDisappear(perform: saveNotifications)
    }
    
    func addNotification() {
        if !newText.isEmpty && notifications.count < 10 {
            let newNotification = NotificationData(text: newText, notificationTime: selectedTime)
            notifications.append(newNotification)
            scheduleNotification(notification: newNotification) // Schedule the notification here
            newText = ""
        }
    }
    
    func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
        // Remove the corresponding scheduled notifications here
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func scheduleNotification(notification: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = "iProgramMe"
        content.body = notification.text

        // Configure the notification trigger based on the selected time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notification.notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create a unique identifier for the notification request
        let identifier = UUID().uuidString

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func loadNotifications() {
        // Load saved notifications here, e.g., from UserDefaults or a database
    }
    
    func saveNotifications() {
        // Save the notifications to persistent storage here
    }
}

struct NotificationData: Identifiable, Codable {
    let id = UUID()
    let text: String
    let notificationTime: Date
}




@available(iOS 15.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        return true
    }
}

*/

/*
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notifications: [NotificationData] = []
    @State private var newText = ""
    @State private var selectedTime = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(notifications) { notification in
                        Text("\(notification.text) at \(formatTime(notification.notificationTime))")
                    }
                    .onDelete(perform: deleteNotification)
                }
                
                HStack {
                    TextField("Enter text", text: $newText)
                    DatePicker("Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                    
                    Button(action: addNotification) {
                        Text("Add")
                    }
                }
            }
            .navigationBarTitle("iProgramMe")
        }
        .onAppear(perform: loadNotifications)
        .onDisappear(perform: saveNotifications)
    }
    
    func addNotification() {
        if !newText.isEmpty && notifications.count < 10 {
            let newNotification = NotificationData(text: newText, notificationTime: selectedTime)
            notifications.append(newNotification)
            scheduleNotification(notification: newNotification) // Schedule the notification here
            newText = ""
        }
    }
    
    func deleteNotification(at offsets: IndexSet) {
        notifications.remove(atOffsets: offsets)
        // Remove the corresponding scheduled notifications here
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func scheduleNotification(notification: NotificationData) {
        let content = UNMutableNotificationContent()
        content.title = "iProgramMe"
        content.body = notification.text

        // Configure the notification trigger based on the selected time
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: notification.notificationTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Create a unique identifier for the notification request
        let identifier = UUID().uuidString

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the notification request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            } else {
                print("Notification scheduled successfully.")
            }
        }
    }
    
    func loadNotifications() {
        // Load saved notifications here, e.g., from UserDefaults or a database
    }
    
    func saveNotifications() {
        // Save the notifications to persistent storage here
    }
}

struct NotificationData: Identifiable, Codable {
    let id = UUID()
    let text: String
    let notificationTime: Date
}


struct iProgramMeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

@available(iOS 15.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
        return true
    }
}

*/

/*
import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var notificationText = ""
    
    var body: some View {
        VStack {
            Text("iProgramMe")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter your text here", text: $notificationText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                scheduleNotifications()
            }) {
                Text("Schedule Notifications")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    func scheduleNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "iProgramMe"
        content.body = notificationText
        
        // Create a trigger to schedule daily notifications
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: DateComponents(hour: 19, minute: 16),
            repeats: true
        )
        
        // Create a notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        // Request authorization to send notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
            if success {
                // Schedule the notification
                UNUserNotificationCenter.current().add(request)
            } else if let error = error {
                print("Error requesting authorization: \(error)")
            }
        }
    }
}


 
 


import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
