//
//  AppDelegate.swift
//  Todoey
//
//  Created by Mac on 8/25/19.
//  Copyright © 2019 beshoy tharwat. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // to print where is our realm file loaction
      //  print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            _ = try Realm()
           
        } catch{
            
            print("Error initialisisng new realm,\(error)")
        }
        
        
        return true
    }





}

