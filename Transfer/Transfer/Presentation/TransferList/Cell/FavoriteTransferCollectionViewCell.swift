//
//  FavoriteTransferCollectionViewCell.swift
//  Transfer
//
//  Created by Fateme on 2023-05-26.
//

import UIKit

class FavoriteTransferCollectionViewCell: UICollectionViewCell {

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()

    private var avatarImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "profile")
        return image
    }()

    private let avatarImageSize: CGFloat = 50

    private var downloadImageUseCase: DownloadImageUseCaseProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        setupViews()
    }

    private func setupViews() {
        setupAvatarImage()
        setupName()
    }

    private func setupName() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    private func setupAvatarImage() {
        self.addSubview(avatarImage)
        avatarImage.layer.cornerRadius =  avatarImageSize/2
        avatarImage.clipsToBounds = true
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImage.widthAnchor.constraint(equalToConstant: avatarImageSize),
            avatarImage.heightAnchor.constraint(equalToConstant: avatarImageSize),
            avatarImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 8)
        ])
    }
}

extension FavoriteTransferCollectionViewCell {
    func bind(_ model: TransferData?, downloadImageUseCase: DownloadImageUseCaseProtocol?) {
        guard let transfer = model else { return }
        nameLabel.text = transfer.name
        self.downloadImageUseCase = downloadImageUseCase
        downloadImageWith(transfer.avatarPath)
    }

    private func downloadImageWith(_ path: String?) {
        guard let path = path else { return }
            self.downloadImageUseCase?.downloadImage(path: path) { [weak self] result in
                guard let `self` = self else { return }
                switch result {
                case .success(let data):
                    self.setAvatarImageWith(data)
                case.failure:
                    break
                }
            }
    }

    private func setAvatarImageWith(_ data: Data?) {
            guard let data = data else { return }
        DispatchQueue.main.async { [weak self] in
            self?.avatarImage.setImage(data)
        }
    }
    
    private func setAvatarImageWith(_ image: UIImage?) {
        DispatchQueue.main.async { [weak self] in
            self?.avatarImage.image = image
        }
    }
}

extension FavoriteTransferCollectionViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
