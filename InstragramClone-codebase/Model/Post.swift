//
//  Post.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/20.
//
import Foundation
import Firebase

struct Post {
    var caption: String
    var likes: Int
    let imageUrl: String
    let ownerUid: String
    let timestamp: Timestamp
    let postId: String
    let ownerImageUrl: String
    let ownerUsername: String
    var didLike = false
    
    init(postId: String, dictionary:[String: Any]) {
        self.postId = postId
        self.caption = dictionary["catpion"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerImageUrl   = dictionary["ownerImageUrl"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        
    }
}
