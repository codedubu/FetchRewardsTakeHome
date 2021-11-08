//
//  SceneDelegate.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let categoriesListVC = CategoriesListVC()
        let rootNC = UINavigationController(rootViewController: categoriesListVC)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = rootNC
        window?.makeKeyAndVisible()
    }
    
    
    func configureNavigationBar() {
        UINavigationBar.appearance().tintColor = .systemPurple
    }
    

    func sceneDidDisconnect(_ scene: UIScene) {

    }
    

    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    

    func sceneWillResignActive(_ scene: UIScene) {

    }
    

    func sceneWillEnterForeground(_ scene: UIScene) {

    }
    

    func sceneDidEnterBackground(_ scene: UIScene) {
 
    }
} // END OF CLASS

