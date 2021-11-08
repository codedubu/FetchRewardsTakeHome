//
//  MealListVC.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class MealListVC: RBActivityIndicatorVC {
    
    var category: Category!
    var meal: Meal?
    var meals: [Meal]               = []
    var filteredMeals: [Meal]       = []
    
    private let tableView           = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getAllMeals()
        configureSearchController()
    }
    

    private func configureViewController() {
        title = category.name.capitalized
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureSearchController() {
        let searchController                                    = UISearchController()
        searchController.searchBar.placeholder                  = Title.mealPlaceholder
        searchController.searchResultsUpdater                   = self
        searchController.obscuresBackgroundDuringPresentation   = false
        navigationItem.hidesSearchBarWhenScrolling              = false
        navigationItem.searchController                         = searchController
    }
    
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.frame = view.bounds
        tableView.rowHeight = 128
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseID)
    }
    
    
    private func getAllMeals() {
        guard let mealName = category?.name else { return }
        showActivityIndicator()
        
        NetworkManager.shared.getAllMeals(meal: mealName) { [weak self] result in
            guard let self = self else { return }
            self.dismissActivityIndicator()
            
            switch result {
            case .success(let meal):
                self.updateUIOnMainThread(with: meal)
                
            case .failure(let error):
                self.presentRBErrorAlertOnMainThread(message: error.localizedDescription)
                self.popVCOnMainThread()
            }
        }
    }
    
    
    private func updateUIOnMainThread(with meal: [Meal]) {
        DispatchQueue.main.async {
            self.meals = meal.sorted { $0.name < $1.name}
            self.filteredMeals = meal.sorted { $0.name < $1.name}
            self.tableView.reloadData()
        }
    }
} // END OF CLASS


// MARK: - Extensions
extension MealListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MealCell.reuseID) as! MealCell
        let meal = self.meals[indexPath.row]
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.set(meal: meal)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        
        let destinationVC = MealDetailVC()
        destinationVC.meal = meal
        
        navigationController?.pushViewController(destinationVC, animated: true)
    }
} // END OF EXTENSION


extension MealListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
     
        self.meals = filteredMeals
        
        guard let searchTerm = searchController.searchBar.text, !searchTerm.isEmpty else {
            self.tableView.reloadDataOnMainThread()
            return
        }
        
        let filteredMeals = meals.filter {
            $0.name.localizedCaseInsensitiveContains(searchTerm)
        }
        
        self.meals = filteredMeals
        self.tableView.reloadDataOnMainThread()
    }
} // END OF EXTENSION
