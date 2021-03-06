//  AppDelegate.swift
//  snoogle
//
//  Created by Vincent Moore on 12/22/16.
//  Copyright © 2016 Vincent Moore. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: NavigationController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "File does not exist")
        
//        do {
//            try FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
//            print("file deleted")
//        } catch let error {
//            print(error)
//        }
        
        let rootController = FeedCollectionController()
        navigationController = NavigationController(rootViewController: rootController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        do {
            let realm = try Realm()
            let app = realm.objects(AppUser.self).first
            if let app = app {
                if app.accounts.isEmpty {
                    window?.rootViewController?.present(LoginViewController(), animated: false, completion: nil)
                }
                if !app.accounts.isEmpty, app.activeAccount == nil {
                    try realm.write {
                        app.activeAccount = app.accounts.first
                    }
                }
            } else {
                let newApp = AppUser()
                try realm.write {
                    realm.add(newApp)
                }
                window?.rootViewController?.present(LoginViewController(), animated: false, completion: nil)
            }
        } catch {
            print(error)
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        } catch {
            print("Error with audio sessions")
        }
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let url = URLComponents(string: url.absoluteString)
        if let queryItems = url?.queryItems {
            let code = queryItems.filter({ (item) in item.name == "code" }).first?.value
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RedditAuthToken"), object: code)
        }
        return true
    }
}
