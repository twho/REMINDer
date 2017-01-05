//
//  AppDelegate.swift
//  REMINDer
//
//  Created by Michael Ho on 12/19/16.
//  Copyright © 2016 reminder.com. All rights reserved.
//

import UIKit
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?

    lazy var client: PubNub = {
        let config = PNConfiguration(publishKey: "pub-c-c7aa66cb-c424-41d7-81b6-7a8240653e10", subscribeKey: "sub-c-20ce2424-d2db-11e6-aef9-02ee2ddab7fe")
        let pub = PubNub.clientWithConfiguration(config)
        return pub
    }()

    override init() {
        super.init()
        self.client.addListener(self)
        self.client.subscribeToChannels(["HyCubeTask"], withPresence: false)
        self.client.subscribeToChannels(["HyCubeChat"], withPresence: false)
    }
    
    @nonobjc func client(client: PubNub, didReceiveStatus status: PNStatus) {
        if status.isError {
            showAlert(error: status.isError.description)
        }
    }
    
    func showAlert(error: String) {
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.window?.rootViewController?.present(alertController, animated: true, completion:nil)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

