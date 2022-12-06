//
//  LoginController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/13.
//

import UIKit
import Then
import SnapKit
import Combine
import CombineCocoa

protocol AuthenticationDelegate: class {
    func authenticationDidComplete()
}

class LoginController: UIViewController {
    
    // MARK: - Properties
    var subscription = Set<AnyCancellable>()
    
    private var viewModel = LoginViewModel()
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage = UIImageView(image: UIImage(named: "Instagram_logo_white")).then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let emailTextField = CustomTextField(placeholder: "Email").then {
        $0.keyboardType = .emailAddress
    }
    
    private let passwordTextField = CustomTextField(placeholder: "Password").then {
        $0.enablesReturnKeyAutomatically = true
        $0.returnKeyType = .send
        $0.isSecureTextEntry = true
    }
    
    private var sinkText = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 24)
        $0.textColor = .white
        
    }
    
    private lazy var loginButton = UIButton(type: .system).then {
        $0.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        $0.isEnabled = false
        //        $0.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .systemPurple.withAlphaComponent(0.5)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Login", for: .normal)
        
        $0.setHeight(50)
    }
    
    private let donthabeAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Forgot your password", secondPart: "Get help signing in.")
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account", secondPart: "Sign Up")
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        passwordTextField.delegate = self
        bind()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(false)
    }
    
    // MARK: - Actions
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        LoadingIndicator.showLoading()
        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print(#fileID, #function, #line, "-")
                LoadingIndicator.hideLoading()
                return
            }
            LoadingIndicator.hideLoading()
            self.delegate?.authenticationDidComplete()
            
        }
    }
    
    @objc func handleShowSignUp() {
        print("DEBUD: Show sign up here...")
        let controller = RegistraionController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    // MARK: - Helpers
    
    func bind() {
        emailTextField.textPublisher
            .compactMap { $0 }
            .assign(to: \.email, on: self.viewModel)
            .store(in: &subscription)
        
        viewModel.$resultValue
            .compactMap{ $0 }
            .assign(to: \.text, on: self.sinkText) //assign 또는 sink를 이용하여 구독을 한다.
            .store(in: &subscription)
        
        //        emailTextField.textPublisher
        //            .compactMap { $0 } //옵셔널 스트링을 언랩핑을 하여 알아서 결과처리를 해준다.
        //            .assign(to: \.email, on: viewModel)
        //            .store(in: &subscription)
        //
        //        viewModel.$email.sink { text in
        //
        //
        //        }.store(in: &subscription)
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(80)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(32)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton, sinkText]).then {
            $0.axis = .vertical
            $0.spacing = 20
        }
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        view.addSubview(donthabeAccountButton)
        donthabeAccountButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16)
        }
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}

// MARK: - FormViewModel

extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            handleShowSignUp()
        } else {
        }
        
        return true
    }
}
