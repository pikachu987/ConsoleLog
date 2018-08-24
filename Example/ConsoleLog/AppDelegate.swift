//
//  AppDelegate.swift
//  ConsoleLog
//
//  Created by pikachu987 on 08/23/2018.
//  Copyright (c) 2018 pikachu987. All rights reserved.
//

import UIKit
import ConsoleLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            ConsoleLog.shared.makeButtonHandler = { (button, type) in
                button.setTitle("", for: .normal)
                if type == ConsoleLogType.default {
                    button.setImage(UIImage(named: "icConsole.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                } else if type == ConsoleLogType.todayLog {
                    button.setImage(UIImage(named: "icTerminalToday.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                } else if type == ConsoleLogType.log {
                    button.setImage(UIImage(named: "icTerminal.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                } else if type == ConsoleLogType.info {
                    button.setImage(UIImage(named: "icInfo.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
            ConsoleLog.shared.show()
            let array = [
                ["name": "Kim", "age": "19", "height": "185cm", "weight": "75kg", "introduce": "Good Morning"],
                ["name": "Lee", "age": "24", "height": "175cm", "weight": "65kg", "introduce": "Hi"],
                ["name": "Seo", "age": "23", "height": "175cm", "weight": "70kg", "introduce": "Welcome"],
                ["name": "Choi", "age": "28", "height": "195cm", "weight": "95kg", "introduce": "Good"]]
            ConsoleLog.shared.custom(level: ConsoleLog.Level.info, message: "Message")
            ConsoleLog.shared.debug(array)
            ConsoleLog.shared.verbose([1, 4, 5, 6, 6, 345, 123, 234, 531, 3462])
            ConsoleLog.shared.error("Error Message Log")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

