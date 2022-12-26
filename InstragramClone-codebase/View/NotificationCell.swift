//
//  NotificationCell.swift
//  InstragramClone-codebase
//
//  Created by HoSeon Chu on 2022/12/23.
//

import Foundation
import UIKit
import SnapKit
import Then

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationCell, wantsToUnfollow uid: String)
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    var viewModel: NotificationViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate? {
        didSet { configure() }
    }
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .lightGray
    }
    
    
    
    private let infoLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    private lazy var postImageView = UIImageView().then {
        $0.isUserInteractionEnabled = true
        
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .lightGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hadlePostTapped))
        $0.addGestureRecognizer(tap)
    }
    
    private lazy var followButton = UIButton(type: .system).then {
        $0.setTitle("Loading", for: .normal)
        $0.layer.cornerRadius = 3
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
        }
        profileImageView.layer.cornerRadius = 48 / 2
        
        
        
        contentView.addSubview(followButton)
        followButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
            $0.width.equalTo(88)
            $0.height.equalTo(32)
        }
        
        contentView.addSubview(postImageView)
        postImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(12)
            $0.width.height.equalTo(40)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.left.equalTo(profileImageView.snp.right).offset(8)
            $0.right.equalTo(followButton.snp.left).inset(4)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    
    @objc func handleProfileImageTapped() {
        
    }
    
    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsToUnfollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func hadlePostTapped() {
        guard let postId = viewModel?.notification.postId else { return }
        
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.postImageUrl)
        postImageView.sd_setImage(with: viewModel.postImageUrl)
        
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
    
    
}
