//
//  ProfileController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/11.
//

import Foundation
import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    // MARK: - Properties
    private var user: User
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        //        fetchUser()
    }
    
    // MARK: - API
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
            self.navigationItem.title = user.username
            
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        navigationItem.title = user.username
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
}

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    //컬렉션 뷰의 본체 내용물
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        
        return cell
    }
    
    //컬렉션 뷰의 헤더 만들기
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        print(#fileID, #function, #line, "-Did cell header function...")
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        
        header.viewModel = ProfileHeaderViewModel(user: user)
        
        return header
    }
}


extension ProfileController {
    
}


extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2) / 3
        
        return CGSize(width: width, height: width)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {
        if user.isCurrentUser {
            print(print(#fileID, #function, #line, "-Show edit profile Header"))
        }
        
        if user.isFollowed {
            print(#fileID, #function, #line, "-Handle follow user here...")
        } else {
            print(#fileID, #function, #line, "- Follow user here")
            UserService.follow(uid: user.uid) { error in
                print(#fileID, #function, #line, "-Did follow user, update UI Now...")
            }
        }
        
    }
    
    
}
