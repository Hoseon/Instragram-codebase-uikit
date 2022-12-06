//
//  FeedController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/11.
//

import Foundation
import UIKit
import Firebase
import SnapKit

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        
    }
    
    // MARK: - Actions
    @objc func handleLogout() {
        do {
            LoadingIndicator.showLoading()
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            LoadingIndicator.hideLoading()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
        } catch {
            LoadingIndicator.hideLoading()
            print(#fileID, #function, #line, "- Logout Error")
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        let testView = UIView()
        testView.backgroundColor = .red
        
//        view.addSubview(testView)
//        testView.snp.makeConstraints {
//            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
        
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(handleLogout))
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
    }
    
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        return cell
    }
}

// MARK: - descriptionUICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width , height: height)
    }
}
