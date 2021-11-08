//
//  CategoriesVC.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class CategoriesListVC: RBActivityIndicatorVC {
    
    var category: Category?
    var categories: [Category]            = []
    var tableView                         = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isBeingPresented || isMovingToParent {
            getAllCategories()
        }
    }
    
    
    private func configureViewController() {
        title = Title.categories
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
    
    
    private func getAllCategories() {
        showActivityIndicator()
        
            NetworkManager.shared.getAllMealCategories { [weak self] result in
                guard let self = self else { return }
                self.dismissActivityIndicator()
                
                switch result {
                case .success(let category):
                    self.updateUIOnMainThread(with: category)
                    
                case .failure(let error):
                    self.presentRBErrorAlertOnMainThread(message: error.localizedDescription)
                }
            }
    }
    
    
    private func updateUIOnMainThread(with category: [Category]) {
        DispatchQueue.main.async {
            self.categories = category.sorted { $0.name < $1.name }
            self.tableView.reloadData()
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
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.set(category: category)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categories = categories
        let category = categories[indexPath.row]
        
        let destinationVC = MealListVC()
        destinationVC.category = category
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
} //END OF EXTENSION
