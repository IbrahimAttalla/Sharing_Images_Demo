//
//  SceneDelegate.swift
//  Sharing_Images_Demo
//
//  Created by it thinkers on 2/26/20.
//  Copyright © 2020 ibrahim-attalla. All rights reserved.
//

import UIKit
import Firebase
import RevealingSplashView


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    

    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        Auth.auth().addStateDidChangeListener { (auth, user) in
            print("auth  " , auth)
            print("user  " ,user)
           
            switch user{
            case nil:
                let loginVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "LoginVC")
                loginVC.modalPresentationStyle = .fullScreen
                self.window?.rootViewController! = loginVC

            default:

                let homeVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MainVC")
                homeVC.modalPresentationStyle = .fullScreen
                self.window?.rootViewController! = homeVC


                
                }
        }
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func openAppOn(storyboard name:String, identifier:String) {
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let initialViewControlleripad : UIViewController = mainStoryboardIpad.instantiateViewController(withIdentifier: identifier) as UIViewController
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialViewControlleripad
        self.window?.makeKeyAndVisible()
        
        // control the splash
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
//        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "photo")!,iconInitialSize: CGSize(width: UIScreen.main.bounds.width - 16, height: 200), backgroundImage: UIImage(named: "photo")!)
//        revealingSplashView.animationType = .swingAndZoomOut
        //Adds the revealing splash view as a sub view
        //let window = UIApplication.sharedApplication.keyWindow
//        window?.addSubview(revealingSplashView)

        //self.view.addSubview(revealingSplashView)
        
        //Starts animation
//        revealingSplashView.startAnimation(){
            print("Completed")
//        }
    }

    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

