//
//  DefaultHeaderCollectionView.swift
//  Transfer
//
//  Created by Fateme on 2023-05-30.
//

import UIKit

class DefaultHeaderCollectionView: UICollectionReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setTitleLabelWith(_ text: String) {
        titleLabel.text = text
        self.backgroundColor = .white
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}

extension DefaultHeaderCollectionView: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
