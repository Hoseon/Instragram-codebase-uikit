//
//  CommentCell.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/21.
//

import Foundation
import UIKit
import Then
import SnapKit

class CommentCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var viewModel: CommentViewModel? {
        didSet { configure() }
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    private let commentLabel = UILabel()
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.width.height.equalTo(40)
        }
        
        commentLabel.numberOfLines = 0
        addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(8)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewmodel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewmodel.profileImageUrl)
        
        commentLabel.attributedText = viewmodel.commentLabelText()
    }
    
    
}
