//
//  PushHandler.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 06.04.2023.
//

import UserNotifications

protocol PushNotificationsHandlerProtocol { }

class PushNotificationsHandler: NSObject, PushNotificationsHandlerProtocol {
    
    private let deepLinksHandler: DeepLinksHandlerProtocol
    
    init(deepLinksHandler: DeepLinksHandlerProtocol) {
        self.deepLinksHandler = deepLinksHandler
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension PushNotificationsHandler: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotification(userInfo: userInfo)
        completionHandler()
    }
    
    func handleNotification(userInfo: [AnyHashable: Any]) {
//        guard let value = getValue("value", userInfo: userInfo), let type = getValue("type", userInfo: userInfo) else {return}
//        let deepLinkType = DeepLink.getLinkType(value: value, type: type)
//        deepLinksHandler.open(deepLink: deepLinkType)
    }
    
    
//    private func getValue(_ key: String, userInfo: [AnyHashable: Any]) -> String?{
//        if let custom = userInfo["custom"] as? [String: Any],
//           let a = custom["a"] as? [String: String]{
//           return a[key]
//        }
//        return nil
//    }
}
