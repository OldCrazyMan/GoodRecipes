//
//  RecipeCollectionViewCell.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 07.02.2022.
//

import UIKit

class RecipeCollectionViewCell: UICollectionViewCell {
    
    var recipesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderWidth = 0.4
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - Override
    
    override func prepareForReuse() {
        recipesImageView.image = nil
       }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setConstraints()
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        
        backgroundColor = .clear
        addSubview(recipesImageView)
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
