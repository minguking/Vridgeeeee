//
//  SceneDelegate.swift
//  Vridgeeeee
//
//  Created by Kang Mingu on 2020/09/14.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = createTabBar()
        window?.makeKeyAndVisible()
    }
    
    func createTabBar() -> UIViewController {
        
        let tabBar = UITabBarController()
        UITabBar.appearance().tintColor = .systemGreen
        tabBar.viewControllers = [
            createHomeNC(),
            createRankingNC(),
            createPostNC(),
            createMyPageNC()
        ]
//        tabBar.selectedIndex = 0
        return tabBar
    }
    
    func createHomeNC() -> UINavigationController {
        let vc = HomeViewController()
        vc.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         tag: 0)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createRankingNC() -> UINavigationController {
        let vc = RankingViewController()
        vc.tabBarItem = UITabBarItem(title: "Ranking",
                                         image: UIImage(systemName: "flame"),
                                         tag: 0)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createPostNC() -> UINavigationController {
        let vc = PostViewController()
        vc.tabBarItem = UITabBarItem(title: "Post",
                                         image: UIImage(systemName: "plus.circle.fill"),
                                         tag: 0)
        
        return UINavigationController(rootViewController: vc)
    }
    
    func createMyPageNC() -> UINavigationController {
        let vc = MyPageViewController()
        vc.tabBarItem = UITabBarItem(title: "My page",
                                         image: UIImage(systemName: "person"),
                                         tag: 0)
        
        return UINavigationController(rootViewController: vc)
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

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

