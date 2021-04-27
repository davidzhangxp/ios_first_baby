//
//  AppDelegate.swift
//  first-baby
//
//  Created by Max Wen on 3/10/21.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import Braintree

@main
class AppDelegate: UIResponder, UIApplicationDelegate{

    func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

            BTAppContextSwitcher.setReturnURLScheme("com.first-baby.payments")

            ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
        FirebaseApp.configure()

        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        setupUIConfigurations()

            return true
        }
    @available(iOS 9.0, *)
        func application(
            _ app: UIApplication,
            open url: URL,
            options: [UIApplication.OpenURLOptionsKey : Any] = [:]
        ) -> Bool {

            ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
            return GIDSignIn.sharedInstance().handle(url)
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
//      -> Bool {
//      return GIDSignIn.sharedInstance().handle(url)
//    }
    
    
    //MARK:- UICongiguration
    private func setupUIConfigurations(){
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = .systemGray6
        UITabBar.appearance().unselectedItemTintColor = .darkGray
        UITabBar.appearance().tintColor = .systemGreen
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.darkGray]
        UINavigationBar.appearance().isTranslucent = false
    }

}

