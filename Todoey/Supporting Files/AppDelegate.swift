//
//  AppDelegate.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit
import RealmSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
     //   print("Realm Path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
       //UserDefaults.standard.set("Menlo", forKey: "font")
        UserDefaults.standard.set("Helvetica neue", forKey: "font")
        UserDefaults.standard.set("Helvetica", forKey: "font")
        
        return true
    }
}

