//
//  AppDelegate.swift
//  mobile
//
//  Created by NguyenSon_MP on 09/02/2023.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        var vc: UIViewController?
            TokenService.tokenInstance.checkForLogin(completionHandler: { success in
                
                if success {
                    DispatchQueue.main.async {
                        vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "MenuTabBar") as? MenuViewController
                        let navVC = UINavigationController(rootViewController: vc!)
                        self.window?.rootViewController = navVC
                        vc?.showToast(message: "Bạn đã đăng nhập", font: .systemFont(ofSize: 12))


                    }
                   
                } else {
                    DispatchQueue.main.async {
                    vc = self.window?.rootViewController?.storyboard?.instantiateViewController(withIdentifier: "LoginFirstScreenViewController") as? LoginFirstScreenViewController
                    let navVC = UINavigationController(rootViewController: vc!)
                    self.window?.rootViewController = navVC
                    }
                }
                



            })
        
        
        // bàn phím thông minh
        IQKeyboardManager.shared.enable = true

        return true


    }
    //khoá xoay màn hình

    var orientationLock = UIInterfaceOrientationMask.all
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
            
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
}
