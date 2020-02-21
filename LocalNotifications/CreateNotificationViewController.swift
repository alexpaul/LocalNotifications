//
//  CreateNotificationViewController.swift
//  LocalNotifications
//
//  Created by Alex Paul on 2/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

protocol CreateNotificationControllerDelegate: AnyObject {
  func didCreateNotification(_ createNotificationController: CreateNotificationViewController)
}

class CreateNotificationViewController: UIViewController {
  
  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  weak var delegate: CreateNotificationControllerDelegate?
  
  private var timeInterval: TimeInterval = Date().timeIntervalSinceNow + 5 // current time plus 5 seconds
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  private func createLocalNotification() {
    // step 1: create the content
    let content = UNMutableNotificationContent()
    content.title = titleTextField.text ?? "No title"
    content.body =  "Local Notifications is awesome when used appropriatly"
    content.subtitle = "Learning Local Notifications"
    content.sound = .default // only works in the background and the app is not on silent - please test on device
    // TODO: you can also import your own sound file
    content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "file.mp3"))
    
    // TODO: userInfo dictionary can hold additional data
    //content.userInfo = ["":""]
    
    // create indentifier
    let identifier = UUID().uuidString // unique String
    
    // attachment
    if let imageURL = Bundle.main.url(forResource: "duck", withExtension: "png") {
      do {
        let attachment = try UNNotificationAttachment(identifier: identifier, url: imageURL, options: nil)
        content.attachments = [attachment]
      } catch {
        print("error with attachment: \(error)")
      }
    } else {
      print("image resource could not be found")
    }
    
    // create trigger
    // 3 possible triggers for local notifications: time interval, calendar, location
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
    
    // create a request
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    
    // add request to the UNNotificationCenter
    UNUserNotificationCenter.current().add(request) { (error) in
      if let error = error {
        print("error adding request: \(error)")
      } else {
        print("request was successfully added")
      }
    }
  }
  
  @IBAction func datePickerChanged(_ sender: UIDatePicker) {
    // to avoid time being in the past
    guard sender.date > Date() else { return }
    
    // timeIntervalSinceNow creates a time stamp of the exact date
    timeInterval = sender.date.timeIntervalSinceNow
  }
  
  @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
    createLocalNotification()
    delegate?.didCreateNotification(self)
    dismiss(animated: true)
  }
  
  
}
