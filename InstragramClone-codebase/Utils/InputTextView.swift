//
//  InputTextView.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/19.
//

import UIKit
import Then
import SnapKit

class InputTextView: UITextView {
    var placeholderText: String? {
        didSet {
            placeholderLabel.text = placeholderText
        }
    }
    
    // MARK: - Properties
    let placeholderLabel = UILabel().then {
        $0.textColor = .lightGray
    }
    
    var placeholderShouldCenter = true {
        didSet {
            if placeholderShouldCenter {
                placeholderLabel.snp.makeConstraints {
                    $0.right.equalToSuperview()
                    $0.left.equalToSuperview().offset(8)
                    $0.centerY.equalToSuperview()
                }
            } else {
                placeholderLabel.snp.makeConstraints {
                    $0.top.equalToSuperview().offset(6)
                    $0.left.equalToSuperview().offset(8)
                }
            }
        }
    }
    
    // MARK: - LifeCycle
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        addSubview(placeholderLabel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextDidChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleTextDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    
    
    
    
    
}
