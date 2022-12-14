//
//  ProfileHeader.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/11/20.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: class {
    func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User)
}

class ProfileHeader: UICollectionReusableView {
    // MARK: - Properties
    
    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .lightGray
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.image = #imageLiteral(resourceName: "venom-7")
        
    }
    
    private let nameLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private lazy var editProfileFollowButton = UIButton(type: .system).then {
        $0.setTitle("Edit Profile", for: .normal)
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
    }
    
    private lazy var postLabel = UILabel().then {
        $0.attributedText = attributedStateText(value: 1, label: "posts")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var followresLabel = UILabel().then {
        $0.attributedText = attributedStateText(value: 1, label: "followers")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var followingLabel = UILabel().then {
        $0.attributedText = attributedStateText(value: 1, label: "following")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let gridButton = UIButton(type: .system).then {
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
        $0.setImage(UIImage(named: "grid"), for: .normal)
        
    }
    
    let listButton = UIButton(type: .system).then {
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
        $0.setImage(UIImage(named: "list"), for: .normal)
    }
    
    let bookmarkButton = UIButton(type: .system).then {
        $0.tintColor = UIColor(white: 0, alpha: 0.2)
        $0.setImage(UIImage(named: "ribbon"), for: .normal)
    }
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
//            $0.top.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.left.equalToSuperview().offset(12)
            $0.width.height.equalTo(80)
        }
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(12)
        }
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.top.equalTo(nameLabel.snp.bottom).offset(16)

        }
        
        //상단에 포스트, 팔로워, 팔로잉
        let stack = UIStackView(arrangedSubviews: [postLabel, followresLabel, followingLabel])
        stack.distribution = .fillEqually
        
        
        addSubview(stack)
        stack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
            $0.right.equalToSuperview().inset(12)
            $0.height.equalTo(50)
        }
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        buttonStack.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        topDivider.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.top)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }
        
        bottomDivider.snp.makeConstraints {
            $0.top.equalTo(buttonStack.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(0.5)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc func handleEditProfileFollowTapped() {
        print(#fileID, #function, #line, "-Handle Edit Profile")
        guard let viewModel = viewModel else { return }
        delegate?.header(self, didTapActionButtonFor: viewModel.user)
    }
    
    // MARK: - Helpers
    func configure() {
        guard let viewModel = viewModel else { return }
        guard let imageUrl = viewModel.profileImageUrl else {return}
        nameLabel.text = viewModel.fullname
        profileImageView.sd_setImage(with: imageUrl)
        
        editProfileFollowButton.setTitle(viewModel.followButtonText, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel.followButtonBackgroundColor
        
        
        
    }
    
    func attributedStateText(value: Int, label: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: label, attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
}
