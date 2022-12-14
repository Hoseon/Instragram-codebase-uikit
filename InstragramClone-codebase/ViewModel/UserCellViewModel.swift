//
//  UserCellViewModel.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/07.
//

import Foundation

struct UserCellViewModel {
    // MARK: - Properties
    private let user: User
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    init(user: User) {
        self.user = user
    }
    
}
