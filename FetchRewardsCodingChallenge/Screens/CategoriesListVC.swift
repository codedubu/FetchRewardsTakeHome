//
//  CategoriesVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class CategoriesListVC: UIViewController {
    
    let tableView                         = UITableView()
    var category: [Category]              = []
    var filteredCategories: [Category]    = []
    var categories: Category?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getAllCategories()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 128
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseID)
    }
    
    
    func getAllCategories() {
        NetworkManager.shared.getMealsBy(categoryID: categories?.id ?? "") { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let category):
                self.category = category
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
        return category.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseID) as! CategoryCell
        let category = self.category[indexPath.row]
        cell.set(category: category)
        
        return cell
    }
} //END OF EXTENSION
