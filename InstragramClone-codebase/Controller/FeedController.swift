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
    
    private var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    var post: Post? {
        didSet { collectionView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchPosts()
        
        if post != nil {
            checkIfUserLikedPosts()
        }
    }
    
    // MARK: - Actions
    @objc func handRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
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
    
    // MARK: - API
    func fetchPosts() {
        guard post == nil else { return }
        
        PostService.fetchFeedPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPosts()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserLikedPosts() {
        self.posts.forEach { post in
            PostService.checkIfUserLikedPost(post: post) { didLike in
                if let index = self.posts.firstIndex(where: {  $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                               style: .plain,
                                                               target: self,
                                                               action: #selector(handleLogout))
        }
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        
        navigationItem.title = "Feed"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
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


//FeedCell의 Delegate Protocol을 여기서 실행
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, wnatsToShowProfileFor uid: String) {
        UserService.fetchUser(withUid: uid) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        guard let tab = tabBarController as? MainTabController else { return }
        guard let user = tab.user else { return }
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            PostService.unlikePost(post: post) { _ in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            PostService.likePost(post: post) { _ in
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                NotificationService.uploadNotification(
                    toUid: post.ownerUid,
                    fromUser: user,
                    type: .like,
                    post: post)
            }
        }
    }
}
