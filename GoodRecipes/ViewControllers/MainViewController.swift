//
//  ViewController.swift
//  GoodRecipes
//
//  Created by Тim Akhm on 31.05.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
    return UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                               style: .plain,
                               target: self,
                               action: #selector(sortBarButtonTapped))
    }()
    
    private lazy var reloadButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "repeat.circle"),
                               style: .plain,
                               target: self,
                               action: #selector(reloadButtonItemTapped))
    }()
    
    private let recipeTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 185
        tableView.separatorInset.right = 10
        tableView.delaysContentTouches = true
        tableView.bounces = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    private let idRecipesTableViewCell = "idRecipesTableViewCell"
    private var isFiltred = false
    
    private var getResults: RecipesModel?
    private var recipeArray = [Recipe]()
    private var filtredArray = [Recipe]()
    
    //MARK: - Override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecipesArray()
        setupSearchBar()
        undateNavButtonsState()
        setupNavigationBar()
        setupViews()
        setDelegate()
        setConstraints()
        
        recipeTableView.register(RecipesTableViewCell.self, forCellReuseIdentifier: idRecipesTableViewCell)
    }
    
    //MARK: - Setups
    
    private func setupViews() {
        reloadButtonItem.isEnabled = false
        view.backgroundColor = .systemBackground
        view.addSubview(recipeTableView)
    }
    
    private func setDelegate() {
        recipeTableView.delegate = self
        recipeTableView.dataSource = self
    }
    
    private func undateNavButtonsState() {
        isFiltred = false
        sortBarButtonItem.isEnabled = true
        reloadButtonItem.isEnabled = false
    }
    
    private func setupSearchBar() {
        let seacrhController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = seacrhController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        seacrhController.searchBar.placeholder = "Search recipe"
        seacrhController.hidesNavigationBarDuringPresentation = false
        seacrhController.obscuresBackgroundDuringPresentation = true
        seacrhController.searchBar.delegate = self
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel(text: "GoodRecipes", font: .timesBold24(), color: #colorLiteral(red: 0.01834024303, green: 0.2141822278, blue: 0.4260755479, alpha: 1), line: 0)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.rightBarButtonItems = [sortBarButtonItem, reloadButtonItem]
    }
    
    //MARK: - GetRecipesArray
    
    private func getRecipesArray() {
        NetworkDataFetch.shared.fetchRecipe { [weak self] result, error in
            guard let self = self else { return }
            
            if error != nil {
                print("Error received requesting data: \(String(describing: error?.localizedDescription))")
            } else {
                guard let result = result else { return }
                self.recipeArray = result.recipes
                self.recipeTableView.reloadData()
            }
        }
    }
    
    //MARK: - FiltringRecipes
    
    private func filtringRecipes(text: String) {
        for recipe in recipeArray {
            if recipe.name.lowercased().contains(text.lowercased()) || recipe.instructions.lowercased().contains(text.lowercased()) {
                filtredArray.append(recipe)
            }
        }
    }
    
    // MARK: - NavigationItems action
    
    @objc private func sortBarButtonTapped(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "", message: "Choose the sorting method:", preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: "Name", style: .default) { (action) in
                                  
            let sortedNameArrayModel = self.recipeArray.sorted{ $0.name < $1.name }
            self.recipeArray.removeAll()
            self.recipeArray = sortedNameArrayModel
            self.recipeTableView.reloadData()
        }
        
        let sortUpdate = UIAlertAction(title: "Last updated", style: .default) { (action) in
            
            let lastUpdatedArray = self.recipeArray.sorted{ $0.lastUpdated < $1.lastUpdated }
            self.recipeArray.removeAll()
            self.recipeArray = lastUpdatedArray
            self.recipeTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(sortName)
        alertController.addAction(sortUpdate)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }

    @objc private func reloadButtonItemTapped(sender: UIBarButtonItem) {
        undateNavButtonsState()
        self.recipeTableView.reloadData()
    }
}
//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltred ? filtredArray.count : recipeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: idRecipesTableViewCell, for: indexPath) as! RecipesTableViewCell
        let recipesModel = (isFiltred ? filtredArray[indexPath.item] : recipeArray[indexPath.item])
        cell.cellConfigure(model: recipesModel)
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterModel = (isFiltred ? filtredArray[indexPath.item] : recipeArray[indexPath.item])
        let detailViewController = DetailsViewController()
        detailViewController.recipeModel = characterModel
        detailViewController.resultsArray = recipeArray
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if let texts = searchBar.text, let textRange = Range(range, in: texts) {
            let updatedText = texts.replacingCharacters(in: textRange, with: text)
            
            filtredArray = [Recipe]()
            isFiltred = (updatedText.count > 0 ? true : false)
            filtringRecipes(text: updatedText)
            recipeTableView.reloadData()
            sortBarButtonItem.isEnabled = (updatedText.count > 0 ? false : true)
            reloadButtonItem.isEnabled = (updatedText.count <= 0 ? false : true)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isFiltred = false
        filtredArray.removeAll()
        return true
    }
     
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        filtringRecipes(text: text)
        recipeTableView.reloadData()
    }
}

//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            recipeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            recipeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            recipeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            recipeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}
