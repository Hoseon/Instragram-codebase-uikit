//
//  ResetPasswordController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/24.
//

import UIKit
import Then
import SnapKit

class ResetPasswordController: UIViewController {
    
    // MARK: - Properties
    private let emailTextField = CustomTextField(placeholder: "Email")
    private var viewModel = ResetPasswordViewModel()
    
    
    private let iconImage = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white")).then {
        $0.contentMode = .scaleAspectFill
    }
    
    
    private let resetPasswordButton = UIButton(type: .system).then {
        $0.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
        $0.setTitle("Reset Passwrod", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .systemPurple.withAlphaComponent(0.5)
        $0.layer.cornerRadius = 5
        $0.setHeight(50)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.isEnabled = false
    }
    
    private let backButton = UIButton().then {
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .white
        
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        configureGradientLayer()
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.left.equalToSuperview().offset(16)
        }
        
        view.addSubview(iconImage)
        iconImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(80)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(32)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(32)
            
        }
    }
    
    // MARK: - Actions
    @objc func handleResetPassword() {
        
    }
    
    @objc func handleDismiss() {
        
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email == sender.text
        }
        
        updateForm()
    }
}


// MARK: - FormViewModel
extension ResetPasswordController: FormViewModel {
    func updateForm() {
        resetPasswordButton.backgroundColor = viewModel.buttonBackgroundColor
        resetPasswordButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        resetPasswordButton.isEnabled = viewModel.formIsValid
    }
}

