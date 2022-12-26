//
//  UploadPostController.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/19.
//

import UIKit
import Then
import SnapKit

protocol UploadPostControllerDelegate: class {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController)
}

class UploadPostController: UIViewController {
    // MARK: - Properties
    
    weak var delegate: UploadPostControllerDelegate?
    
    var currentUser: User?
    
    var selectedImage: UIImage? {
        didSet {
            photoImageView.image = selectedImage
        }
    }
    private let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private lazy var catpionTextView = InputTextView().then {
        $0.delegate = self
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.placeholderText = "Enter caption..."
    }
    
    private let characterCountLabel = UILabel().then{
        $0.text = "0/100"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .lightGray
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTabDone() {
        guard let image = selectedImage else { return }
        guard let caption = catpionTextView.text else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        
        PostService.uploadPost(caption: caption, image: image, user: user) { error in
            self.showLoader(false)
            
            if let error = error {
                print("DEBUG: 이미지 업로드 에러 \(error.localizedDescription)")
                return
            }
            
            self.delegate?.controllerDidFinishUploadingPost(self)
        }
        
    }
    
    // MARK: - Helpers
    func checkMaxLength(_ textView: UITextView, maxLength: Int) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
     }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTabDone))
        
        view.addSubview(photoImageView)
        photoImageView.layer.cornerRadius = 10
        photoImageView.snp.makeConstraints {
            $0.height.equalTo(180)
            $0.width.equalTo(180)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(catpionTextView)
        catpionTextView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(64)
        }
        
        view.addSubview(characterCountLabel)
        characterCountLabel.snp.makeConstraints {
            $0.bottom.equalTo(catpionTextView.snp.bottom).offset(12)
            $0.right.equalToSuperview().inset(12)
            
        }
    }
}

// MARK: - UITextFieldDelegate
extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
        
//        catpionTextView.placeholderLabel.isHidden = !catpionTextView.text.isEmpty
    }
}
