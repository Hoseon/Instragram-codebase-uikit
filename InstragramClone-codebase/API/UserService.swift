//
//  UserService.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/20.
//

import Firebase

typealias FireStoreCompletion = (Error?) -> Void

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapShot, error in
            guard let dictionary = snapShot?.data() else {return}
            
            if let error = error {
                print(#fileID, #function, #line, "-Firebase Get User Error \(error)")
            }
            
            let user = User(dictionary: dictionary)
            completion(user)
            
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            let users = snapshot.documents.map({User(dictionary: $0.data())})
            completion(users)
        }
    }
    
    static func follow(uid: String, completion: @escaping(FireStoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in
            COLLECTION_FOLLOWERS.document(uid).collection("user-followers").document(currentUid).setData([:], completion: completion)
        }
    }
    
    static func unfollow(uid: String, completion: @escaping(FireStoreCompletion)) {
        
    }
}
