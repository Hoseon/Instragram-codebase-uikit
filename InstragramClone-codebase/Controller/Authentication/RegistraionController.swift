//
//  LoginController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/13.
//

import UIKit
import Then
import SnapKit

class RegistraionController: UIViewController {
    
    // MARK: - Properties
    private var viewModel22 = RegistrationViewModel()
    private var profileImage: UIImage?
    
    weak var delegate : AuthenticationDelegate?
    
    private let plushPhotoButton = UIButton().then {
        $0.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        $0.tintColor = .black
        $0.setImage(UIImage(named: "plus_photo"), for: .normal)
    }
    
    private let emailTextField = CustomTextField(placeholder: "Email").then {
        $0.keyboardType = .emailAddress
    }
    
    private let passwordTextField = CustomTextField(placeholder: "Password").then {
        $0.isSecureTextEntry = true
        
    }
    
    private let fullnameTextField = CustomTextField(placeholder: "FullName")
    
    private let usernameTextField = CustomTextField(placeholder: "UserName")
    
    private var signUpButton = UIButton(type: .system).then {
        $0.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        $0.isEnabled = false
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .systemPurple
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Sign Up", for: .normal)
        $0.setHeight(50)
    }
    
    private lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Already have an account?", secondPart: "Sign Up")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
    }
    
    // MARK: - Actions
    @objc func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credentials = AuthCredentials(
            email: email, password: password, fullname: fullname, username: username, profileImage: profileImage
        )
        
        AuthService.registerUser(withCredential: credentials) { (error) in
            if let error = error {
                print("DEBUG: Failed to register user \(error.localizedDescription)")
                return
            }
            
            self.delegate?.authenticationDidComplete()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel22.email = sender.text
            
        } else if sender == passwordTextField {
            viewModel22.password = sender.text
            
        } else if sender == fullnameTextField {
            viewModel22.fullname = sender.text
            
        } else {
            viewModel22.username = sender.text
            
        }
        
        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        print("DEBUG: Show photo library here..")
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plushPhotoButton)
        plushPhotoButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(140)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, signUpButton]).then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(plushPhotoButton.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    
}

// MARK: - FormViewModel

extension RegistraionController: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel22.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel22.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel22.formIsValid
    }
}

extension RegistraionController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        profileImage = selectedImage
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor.white.cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        self.dismiss(animated: true, completion: nil)
        
    }
}


