//
//  FavoriteCollectionViewCell.swift
//  iTunes Client App
//
//  Created by GÜRHAN YUVARLAK on 10.10.2022.
//

import UIKit
import CoreData

final class FavoriteCollectionViewCell: UICollectionViewCell {
    
    var favoriteDelegate: FavoriteProtocol?
    
    var favorite: NSManagedObject?
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        layer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.locations = [0.0, 1.0]
        return layer
    }()
    
    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21.0)
        label.textColor = .white
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var likedButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.backgroundColor = .lightGray
        button.tintColor = .red
        button.layer.cornerRadius = 12
        button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
        button.addTarget(self, action: #selector(didTapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        imageView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 16.0),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.0),
            titleLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -8.0)
        ])
        
        imageView.layer.insertSublayer(gradientLayer, at: .zero)
        
        addSubview(likedButton)
        likedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likedButton.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 15.0),
            likedButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -15.0),
            likedButton.heightAnchor.constraint(equalToConstant: 40.0),
            likedButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    @objc private func didTapFavoriteButton() {
        guard let favorite = favorite else {
            return
        }
        self.favoriteDelegate?.didTapLikedButton(item: favorite)
    }
}

