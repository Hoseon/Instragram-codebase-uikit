//
//  ProfileCell.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/20.
//

import UIKit
import SnapKit
import Then

class ProfileCell: UICollectionViewCell {
    // MARK: - ProPerties
    
    private let postImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "venom-7")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
