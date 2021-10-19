//
//  CategoriesVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class CategoriesListVC: UIViewController {
    
    private let tableView                 = UITableView()
    var categories: [Category]            = []
    var filteredCategories: [Category]    = []
    var category: Category?
    private var isSearching               = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getAllCategories()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    private func configureViewController() {
        title = "Categories"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 128
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
    }
    
    
    func getAllCategories() {
        NetworkManager.shared.getAllMealCategories(categoryID: category?.id ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let category):
                self.categories = category.sorted { $0.name < $1.name }
                self.tableView.reloadDataOnMainThread()
                
            case .failure(let error):
                print("\(error)")
            }
        }
    }
} // END OF CLASS


// MARK: - Extensions
extension CategoriesListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID) as! CategoryCell
        let category = self.categories[indexPath.row]
        cell.set(category: category)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredCategories : categories
        let category = activeArray[indexPath.row]
        
        let destinationVC = MealListVC()
        destinationVC.category = category
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
} //END OF EXTENSION
