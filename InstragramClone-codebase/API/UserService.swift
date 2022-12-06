//
//  UserService.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/20.
//

import Firebase

struct UserService {
    static func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).getDocument { snapShot, error in
            guard let dictionary = snapShot?.data() else {return}
            
            if let error = error {
                print(#fileID, #function, #line, "-Firebase Get User Error \(error)")
            }
//            print(#fileID, #function, #line, "-Firebase Get Data : \(snapShot?.data())")
            
            let user = User(dictionary: dictionary)
            completion(user)
            
        }
    }
}
