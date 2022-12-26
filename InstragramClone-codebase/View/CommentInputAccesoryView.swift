//
//  CommentInputAccesoryView.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/21.
//

import Foundation
import UIKit

protocol CommentInpuAccesoryViewDelegate: class {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: CommentInpuAccesoryViewDelegate?
    
    private let commentTextView = InputTextView().then {
        $0.placeholderShouldCenter = false
        $0.placeholderText = "Enter comment.."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.isScrollEnabled = false
    }
    
    private let postButton = UIButton(type: .system).then {
        $0.addTarget(self, action: #selector(handlePostTapped), for: .touchUpInside)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitle("Post", for: .normal)
    }
    
    private let divider = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(postButton)
        postButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        addSubview(commentTextView)
        commentTextView.snp.makeConstraints {
            $0.top.left.equalToSuperview().offset(8)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            $0.right.equalTo(postButton.snp.left).offset(8)
            $0.height.equalTo(50)
        }
        
        addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Actions
    @objc func handlePostTapped() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }
    
    // MARK: - Helpers
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
        
    }
    
}
