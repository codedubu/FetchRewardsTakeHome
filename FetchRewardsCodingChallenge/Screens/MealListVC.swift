//
//  MealListVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class MealListVC: UIViewController {
    
    private let tableView           = UITableView()
    var category: Category!
    var meal: Meal?
    var meals: [Meal]               = []
    var filteredMeals: [Meal]       = []
    private var isSearching         = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        getAllMeals()
    }
    
    
    private func configureViewController() {
        title = category.name
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
        
        tableView.register(MealCell.self, forCellReuseIdentifier: MealCell.reuseID)
    }
    
    
    func getAllMeals() {
        guard let mealID = category?.name else { return }
        
        NetworkManager.shared.getAllMeals(mealID: mealID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let meal):
                self.meals = meal.sorted { $0.name < $1.name}
                self.tableView.reloadDataOnMainThread()
            case .failure(let error):
                print("\(error)")
            }
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
        cell.set(meal: meal)
        
        return cell
    }
} // END OF EXTENSION
