//
//  RandomCollectionViewCell.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 24.04.2022.
//

import UIKit

class RandomCollectionViewCell: UICollectionViewCell {
    
    let recipesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    //MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recipesImageView.layer.cornerRadius = recipesImageView.frame.width / 10
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
   
    //MARK: - SetupViews
    
    private func setupViews() {
        backgroundColor = .none
        addSubview(recipesImageView)
    }
    
    //MARK: - ConfigureCell
    
    func cellConfigure(model: Recipe) {
        let urlString = model.images
        
        NetworkImageFetch.shared.fetchImage(from: urlString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.recipesImageView.image = image
            case .failure(_):
                print("Error received requesting image: 401")
            }
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            recipesImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            recipesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            recipesImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            recipesImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
