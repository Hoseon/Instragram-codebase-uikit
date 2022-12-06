//
//  ProfileHeaderViewModel.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/20.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
    
    init(user: User) {
        self.user = user
    }
}
