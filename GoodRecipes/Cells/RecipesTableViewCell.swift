//
//  RecipesTableViewCell.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 30.05.2022.
//

import UIKit

class RecipesTableViewCell: UITableViewCell {
    
    private var recipesImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.1
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel = UILabel(text: " ",
                                    font: UIFont.boldSystemFont(ofSize: 17),
                                    color: #colorLiteral(red: 0.01834024303, green: 0.2141822278, blue: 0.4260755479, alpha: 1),
                                    line: 0)

    private let descriptionLabel = UILabel(text: " ",
                                           font: .timesNR16(),
                                           color: #colorLiteral(red: 0.01732282468, green: 0.2434297162, blue: 0.493919147, alpha: 1),
                                           line: 2)

    private let difficultLabel = UILabel(text: " ",
                                         font: .timesNR16(),
                                         color: #colorLiteral(red: 0.01753609349, green: 0.2464266851, blue: 0.5, alpha: 1),
                                         line: 0)
    
    //MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recipesImageView.layer.cornerRadius = recipesImageView.frame.width / 10
    }
    
    override func prepareForReuse() {
        recipesImageView.image = nil
       }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        setConstraints()
    }
            
    //MARK: - SetupViews
    
    private func setupViews() {
        
        backgroundColor = .clear
        
        addSubview(recipesImageView)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        addSubview(difficultLabel)
    }
    
    //MARK: - ConfigureCell
    
    func cellConfigure(model: Recipe) {
        nameLabel.text = model.name
        difficultLabel.text = "Difficulty: \(String(model.difficulty))"
        descriptionLabel.text = model.recipeDescription
        
        if descriptionLabel.text == nil {
            descriptionLabel.text = "The recipe does not require a description, it is very tasty!"
        } else if descriptionLabel.text == "" {
            descriptionLabel.text = "An unsurpassably delicious dinner for the whole family."
        }
        
        let urlString = model.images
        
        NetworkImageFetch.shared.fetchImage(from: urlString) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self.recipesImageView.image = image
            case .failure(_):
                print("Error received requesting image: 400")
            }
        }
    }
    
    //MARK: - SetConstraints
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([
            recipesImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            recipesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            recipesImageView.widthAnchor.constraint(equalToConstant: 150),
            recipesImageView.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: recipesImageView.topAnchor, constant: 0),
            nameLabel.leadingAnchor.constraint(equalTo: recipesImageView.trailingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: recipesImageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            difficultLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            difficultLabel.leadingAnchor.constraint(equalTo: recipesImageView.trailingAnchor, constant: 10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

