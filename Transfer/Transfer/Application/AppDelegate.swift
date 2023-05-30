//
//  AppDelegate.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinatorProtocol?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appFlowCoordinator = appDIContainer.makeAppFlowCoordinator(navigationController: navigationController)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
}
