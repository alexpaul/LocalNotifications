# LocalNotifications

Working with Local Notifications and the UserNotifications framework. 

## 1. Requesting Permissions to use Notifications 

Check for authorization status
```swift 
UNUserNotificationCenter.current().getNotificationSettings { (settings) in
  if settings.authorizationStatus == .authorized {
    //
  } else {
    self.requestNotificationPermissions()
  }
}
```

Request authorization
```swift 
let center = UNUserNotificationCenter.current()
center.requestAuthorization(options: [.alert, .sound, .announcement, .carPlay]) { (granted, error) in
  if let error = error {
    // error encountered
    print("error encountered: \(error)")
    return
  }
  if granted {
    print("access granted")
  } else {
    print("access denied")
  }
}
```

## 2. Create the Notification's content 

```swift 
let content = UNMutableNotificationContent()
content.title = "Code Alert"
content.body = "Starting the day with code"
```

## 3. Create the trigger

```swift 
let timeInterval = Date().timeIntervalSinceNow + 5
let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
```

#### Types of Local Notification Triggers 

1. UNCalendarNofificationTrigger
2. UNTimeIntervalNotificationTrigger 
3. UNLocationNotificationTrigger

## 4. Create and register a Notification request 

```swift 
let identifier = "sundayAlarm"
let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
```

## 5. Schedule the request with the system 

```swift 
center.add(request) { (error) in
  if let error = error {
    print("request error: \(error)")
  }
}
```

## 6. In-app Notifications 

#### Registering as the delegate for the UNNotificationCenterDelegate

```swift 
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  // Override point for customization after application launch.
  configureNoficationCenter()
  return true
}
```

#### Conforming to the UNNotificationCenterDelegate

```swift 
extension AppDelegate: UNUserNotificationCenterDelegate {
  func configureNoficationCenter() {
    UNUserNotificationCenter.current().delegate = self
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    // code here
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }
}
```

## 7. Adding content attachments 

```swift 
let imageURL = Bundle.main.url(forResource: "pursuit-logo", withExtension: "png")!
do {
  let attachment = try UNNotificationAttachment(identifier: "sundayAlarm", url: imageURL)
  content.attachments = [attachment]
} catch {
  print("could not load attached with error: \(error)")
}
```

## 8. Get pending notification requests 

```swift 
UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
  let request = requests.filter { $0.identifier == "sundayAlarm" }
  dump(request)
}
```

## 9. Remove a pending notification request

```swift 
UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["sundayAlarm"])
```

## 10. Adding a custom sound file 

```swift 
content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "deduction.mp3"))//.default
```
