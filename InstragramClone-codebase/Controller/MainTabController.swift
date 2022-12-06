//
//  MainTabController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/11.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - LifeCycle
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - Helpers
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: UIImage(named: "home_selected")!, selectedImage: UIImage(named: "home_unselected")!, rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: UIImage(named: "search_selected")!, selectedImage: UIImage(named: "search_unselected")!, rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: UIImage(named: "plus_unselected")!, selectedImage: UIImage(named: "plus_unselected")!, rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: UIImage(named: "like_selected")!, selectedImage: UIImage(named: "like_unselected")!, rootViewController: NotificationController())
        
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: UIImage(named: "profile_selected")!, selectedImage: UIImage(named: "profile_unselected")!, rootViewController: profileController)
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print(#fileID, #function, #line, "-Auth did complete, Fetch user and update here..")
        fetchUser()
        self.dismiss(animated: true, completion: nil)
    }
}
