//
//  CustomTextField.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/14.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        
        let spacer = UIView()
        spacer.setDimensions(height: 50, width: 12)
        leftView = spacer
        leftViewMode = .always
        
//        layer.cornerRadius = 8
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(white: 1, alpha: 0.7)])
        backgroundColor = UIColor(white: 1, alpha: 0.1)
        keyboardAppearance = .dark
        textColor = .white
        borderStyle = .none
        setHeight(50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
