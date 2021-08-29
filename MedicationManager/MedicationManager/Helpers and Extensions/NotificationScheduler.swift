//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Ben Erekson on 7/28/21.
//

import UserNotifications

class NotificationScheduler{
    
    func scheduleNotification(for medicaiton: Medication) {
        guard let timeOfDay = medicaiton.timeOfDay,
              let identifier = medicaiton.id?.uuidString else { return }
        
        clearNotifications(for: medicaiton)
        
        ///https://www.youtube.com/watch?v=9Tnux7K3MOQ
        let content = UNMutableNotificationContent()
        content.title = "TAKE YOUR MEDICATION!!!"
        content.body = "Its time to take \(medicaiton.name ?? StringConstants.medication)!"
        content.sound = .default
        content.userInfo = [StringConstants.medicationID: identifier]
        content.categoryIdentifier = StringConstants.medicationReminderCategoryIdentifier
        
        let fireDateComponents = Calendar.current.dateComponents([.hour, .minute], from: timeOfDay)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Unable to add notification request \(error.localizedDescription)")
            }
        }
    }
    
    func clearNotifications(for medicaiton: Medication) {
        guard let identifier = medicaiton.id?.uuidString else { return }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    
}//End Of Class
