//
//  DetailsViewController.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 24.04.2022.
//

import UIKit

class DetailsViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = recipeModel?.images.count ?? 0
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.01834024303, green: 0.2141822278, blue: 0.4260755479, alpha: 1)
        pageControl.isEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private let recipCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let moreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let recipeDescriptionLabel = UILabel(text: "Description:",
                                                 font: UIFont.boldSystemFont(ofSize: 21),
                                                 color: .darkText,
                                                 line: 0)
    
    private let instructionLabel = UILabel(text: "Instructions:",
                                           font: UIFont.boldSystemFont(ofSize: 21),
                                           color: .black, line: 0)
    
    private let difficultyLabel = UILabel(text: "Difficulty:",
                                          font: UIFont.boldSystemFont(ofSize: 21),
                                          color: .black,
                                          line: 0)
    
    private let textDescriptionLabel = UILabel(text: " ",
                                               font: .timesNR22(),
                                               color: .black,
                                               line: 0)
    
    private let textInstructionLabel = UILabel(text: " ",
                                               font: .timesNR22(),
                                               color: .black,
                                               line: 0)
    
    private let textDifficultyLabel = UILabel(text: " ",
                                              font: .timesNR22(),
                                              color: .black,
                                              line: 0)
    
    private let moreTextLabel = UILabel(text: "More recipes:",
                                        font: UIFont.italicSystemFont(ofSize: 22),
                                        color: .black,
                                        line: 0)
    
    private var descriptionStackView = UIStackView()
    private var instructionsStackView = UIStackView()
    private var difficultyStackView = UIStackView()
    
    private let idRandomCharacterCollectionViewCell = "idRandomCharacterCollectionViewCell"
    private let idRecipeCollectionViewCell = "idRecipeCollectionViewCell"
    
    var recipeModel: Recipe?
    var resultsArray = [Recipe]()
    private var randomArray = [Recipe]()
    private var arImages = [UIImage]()
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecipeInfo()
        getRandomRecip()
        
        setupViews()
        setDelegates()
        setConstraints()
    }
    
    //MARK: - Setups
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        
        descriptionStackView =  UIStackView(arrangedSubviews: [recipeDescriptionLabel, textDescriptionLabel],
                                            axis: .vertical,
                                            spacing: 5)
        
        instructionsStackView =  UIStackView(arrangedSubviews: [instructionLabel, textInstructionLabel],
                                             axis: .vertical,
                                             spacing: 5)
        
        difficultyStackView =  UIStackView(arrangedSubviews: [difficultyLabel, textDifficultyLabel],
                                           axis: .vertical,
                                           spacing: 5)
        
        scrollView.addSubview(recipCollectionView)
        scrollView.addSubview(pageControl)
        scrollView.addSubview(descriptionStackView)
        scrollView.addSubview(instructionsStackView)
        scrollView.addSubview(difficultyStackView)
        scrollView.addSubview(moreTextLabel)
        scrollView.addSubview(moreCollectionView)
        
        recipCollectionView.register(RecipeCollectionViewCell.self, forCellWithReuseIdentifier: idRecipeCollectionViewCell)
        moreCollectionView.register(RandomCollectionViewCell.self, forCellWithReuseIdentifier: idRandomCharacterCollectionViewCell)
    }
    
    private func setDelegates() {
        moreCollectionView.dataSource = self
        moreCollectionView.delegate = self
        
        recipCollectionView.dataSource = self
        recipCollectionView.delegate = self
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.x
        let width = scrollView.frame.height
        let horizontalCenter = width / 2
        pageControl.currentPage = Int(offSet + horizontalCenter) / Int(width)
    }
    
    //MARK: - SetupRecipeInfo
    
    private func setupRecipeInfo() {
        
        guard let recipeModel = recipeModel else { return }
        title = recipeModel.name
        textInstructionLabel.attributedText = recipeModel.instructions.htmlAttributed(using: .timesNR20() ?? UIFont.systemFont(ofSize: 20))
        textDifficultyLabel.text = String(recipeModel.difficulty)
        textDescriptionLabel.text = recipeModel.recipeDescription
        
        if textDescriptionLabel.text == nil {
            textDescriptionLabel.text = "The recipe does not require a description, it is very tasty!"
        } else if textDescriptionLabel.text == "" {
            textDescriptionLabel.text = "An unsurpassably delicious dinner for the whole family."
        }
    }
    
    private func getRandomRecip() {
        for _ in 0...6 {
            let randomInt = Int.random(in: 0...resultsArray.count - 1)
            randomArray.append(resultsArray[randomInt])
        }
        
        let sortAr = unique(source: self.randomArray)
        randomArray = sortAr
    }
    
    func unique<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}
//MARK: - UICollectionViewDataSource

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == moreCollectionView {
            return randomArray.count
        } else {
            return recipeModel?.images.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == moreCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idRandomCharacterCollectionViewCell, for: indexPath)
            as! RandomCollectionViewCell
            
            let characterModel = randomArray[indexPath.row]
            cell.cellConfigure(model: characterModel)
            return cell
            
        } else {
            
            let cellTwo = collectionView.dequeueReusableCell(withReuseIdentifier: idRecipeCollectionViewCell, for: indexPath) as! RecipeCollectionViewCell
            
            guard let urlString = recipeModel?.images else { return cellTwo}
            
            NetworkImageFetch.shared.fetchImage(from: urlString) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    for _ in 0...0 {
                        guard let image = image else { return }
                        self.arImages.append(image)
                    }
                case .failure(_):
                    print("Error received requesting image: 403")
                }
                
                let sortAr = self.unique(source: self.arImages)
                let imageAr = sortAr[indexPath.item]
                
                DispatchQueue.main.async() {
                    cellTwo.recipesImageView.image = imageAr
                }
            }
            return cellTwo
        }
    }
}

//MARK: - UICollectionViewDelegate

extension DetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == moreCollectionView {
            let characterModel = randomArray[indexPath.row]
            let detailViewController = DetailsViewController()
            detailViewController.recipeModel = characterModel
            detailViewController.resultsArray = resultsArray
            navigationItem.backButtonTitle = ""
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == moreCollectionView {
            return CGSize(width: collectionView.frame.height,
                          height: collectionView.frame.height)
            
        } else {
            return CGSize(width: collectionView.frame.width,
                          height: collectionView.frame.height)
        }
    }
}

//MARK: - SetConstraints

extension DetailsViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            recipCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            recipCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            recipCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            recipCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: recipCollectionView.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: recipCollectionView.bottomAnchor, constant: 5),
        ])
        
        NSLayoutConstraint.activate([
            descriptionStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 5),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            instructionsStackView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 16),
            instructionsStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            instructionsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            difficultyStackView.topAnchor.constraint(equalTo: instructionsStackView.bottomAnchor, constant: 16),
            difficultyStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            difficultyStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            moreTextLabel.topAnchor.constraint(equalTo: difficultyStackView.bottomAnchor, constant: 40),
            moreTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moreTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            moreCollectionView.topAnchor.constraint(equalTo: moreTextLabel.bottomAnchor, constant: 10),
            moreCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            moreCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            moreCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            moreCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20)
        ])
    }
}
