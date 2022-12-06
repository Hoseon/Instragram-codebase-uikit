//
//  AuthenticationViewModel.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/14.
//

import UIKit
import Combine

protocol FormViewModel {
    func updateForm()
}

protocol AuthenticationViewModel {
    var formIsValid: Bool { get }
    var buttonBackgroundColor: UIColor { get }
    var buttonTitleColor: UIColor { get }
}

class LoginViewModel: ObservableObject, AuthenticationViewModel {
    
    // MARK: - Properties
    var subscription = Set<AnyCancellable>()
    
    // Input 뷰모델에 들어 오는 녀석
    @Published var email: String?
    @Published var password: String?
    
    // OutPut 뷰모델에서 나가는 녀석
    @Published var resultValue: String = ""
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
    
    // MARK: - LifeCycle
    init() {
        Publishers
            .CombineLatest($email, $password)
            .map {textValue1, textValue2 -> String in
                return "\(textValue1 ?? "")\(textValue2 ?? "")"
        }
            .assign(to: \.resultValue , on: self)
            .store(in: &subscription)
    }
    
    
}

struct RegistrationViewModel: AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var buttonBackgroundColor: UIColor {
        return formIsValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) : #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
    }
    
    var buttonTitleColor: UIColor {
        return formIsValid ? .white : UIColor(white: 1, alpha: 0.67)
    }
}
