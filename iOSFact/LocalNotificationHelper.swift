//
//  LocalNotificationHelper.swift
//  iOSFact
//
//  Created by James Daniell on 19/01/2017.
//  Copyright © 2017 JamesDaniell. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationHelper: NSObject , UNUserNotificationCenterDelegate
{
    
    func checkNotificationEnabled() -> Bool
    {
        // Check if the user has enabled notifications for this app and return True / False
        guard let settings = UIApplication.shared.currentUserNotificationSettings else { return false}
        if settings.types == .none
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    func checkNotificationExists(taskTypeId: String) -> Bool
    {
        // Loop through the pending notifications
        var result: Bool = false
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests
            {
                if( request.identifier ==  String(taskTypeId))
                {
                    result = true
                }
            }
        })
        return result
        
    }
    func scheduleNotification(date: Date)
    {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar , timeZone: .current, month: components.month , day: components.day, hour: components.hour)
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.title = "Optimise your learning"
        content.body = " You have Question(s)"
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: "QuestionRequest", content: content, trigger: trigger)
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error
            {
                print("There was an error creating Notification: \(error)")
            }
        }
        
    }
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        // Play sound and show alert to the user
        completionHandler([.alert,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        
        // Determine the user action
        switch response.actionIdentifier
        {
            case UNNotificationDismissActionIdentifier:
                print("Dismiss Action")
            case UNNotificationDefaultActionIdentifier:
                print("Default")
            case "Snooze":
                print("Snooze")
            case "Delete":
                print("Delete")
            default:
                print("Unknown action")
        }
        completionHandler()
    }
    func removeNotification(taskTypeId: String)
    {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests
            {
                if( request.identifier ==  String(taskTypeId))
                {
                    center.removePendingNotificationRequests(withIdentifiers: [taskTypeId])
                    print("Notification deleted for taskTypeID: \(taskTypeId)")
                }
            }
        })

    }
    func listNotifications() -> [UILocalNotification]
    {
        var localNotify:[UILocalNotification]?
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification] {
            localNotify?.append(notification)
        }
        return localNotify!
    }
    
    func printNotifications() {
        
        print("List of notifications currently set:- ")
        
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification]
        {
            print ("\(notification)")
        }
    }
}
