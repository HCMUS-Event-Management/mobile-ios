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
        // bàn phím thông minh
        IQKeyboardManager.shared.enable = true

        performLoginFlow()

        
      
        return true


    }
    
    
    func performLoginFlow() {
        TokenService.tokenInstance.checkForLogin(completionHandler: { success in
                if success {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "MenuTabBar") as? MenuViewController
                        let navVC = UINavigationController(rootViewController: vc!)
                        self.window?.rootViewController = navVC
                        vc?.showToast(message: "Bạn đã đăng nhập", font: .systemFont(ofSize: 12))
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginFirstScreenViewController") as? LoginFirstScreenViewController
                        let navVC = UINavigationController(rootViewController: vc!)
                        self.window?.rootViewController = navVC
                    }
                }
            })
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let scheme = url.scheme, scheme == "myapp" { // Thay "myapp" bằng URLScheme của bạn
            if let host = url.host, host == "response" { // Kiểm tra phần host của URL (nếu cần)
                // Lấy dữ liệu phản hồi từ URL
                if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems {
                    for item in queryItems {
                        if item.name == "data" {
                            if let response = item.value {
                                // Xử lý dữ liệu phản hồi
                                print("Response data: \(response)")
                                // Tiếp tục xử lý dữ liệu và thực hiện các bước tiếp theo
                                // ...
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }

    
}
