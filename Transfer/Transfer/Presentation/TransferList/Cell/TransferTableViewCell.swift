//
//  TransferTableViewCell.swift
//  Transfer
//
//  Created by Fateme on 2023-05-25.
//

import UIKit

class TransferTableViewCell: UITableViewCell {

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

    private var favImage: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private var arrowImage: UIImageView = {
        let view = UIImageView()
        return view
    }()


    private let avatarImageSize: CGFloat = 50

    private var downloadImageUseCase: DownloadImageUseCaseProtocol?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func commonInit() {
        selectionStyle = .none
        setupViews()
    }

    private func setupViews() {
        setupAvatarImage()
        setupArrowImageView()
        setupFavImageView()
        setupName()
    }

    private func setupName() {
        self.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: avatarImage.rightAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            nameLabel.rightAnchor.constraint(equalTo: favImage.leftAnchor, constant: -8)
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
            avatarImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            avatarImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }

    private func setupFavImageView() {
        self.addSubview(favImage)
        favImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favImage.heightAnchor.constraint(equalToConstant: 20),
            favImage.widthAnchor.constraint(equalToConstant: 20),
            favImage.rightAnchor.constraint(equalTo: arrowImage.leftAnchor, constant: -8),
            favImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupArrowImageView() {
        self.addSubview(arrowImage)
        arrowImage.image = UIImage(named: "arrow")
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImage.heightAnchor.constraint(equalToConstant: 30),
            arrowImage.widthAnchor.constraint(equalToConstant: 30),
            arrowImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            arrowImage.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension TransferTableViewCell {
    func bind(_ model: TransferData?, downloadImageUseCase: DownloadImageUseCaseProtocol?) {
        guard let transfer = model else { return }
        nameLabel.text = transfer.name
        self.downloadImageUseCase = downloadImageUseCase
        downloadImageWith(transfer.avatarPath)
        steFavImage(isFav: transfer.isFav ?? false)
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

    private func steFavImage(isFav: Bool) {
        favImage.isHidden = !isFav
        favImage.image = isFav ? UIImage(named: "fav") : UIImage(named: "unFav")
    }
}

extension TransferTableViewCell: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
