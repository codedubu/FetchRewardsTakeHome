//
//  MealDetailVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealDetailVC: FRActivityIndicatorVC {
    
    var mealy: Mealy!
    var ingredientys: [Ingredienty] = []
    var ingredientyy: Ingredienty?
    
    var meal: Meal!
    var ingredient: Ingredient?
    var ingredients: [Ingredient]   = []
    private let tableView           = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
//        getAllIngredients()
        getAllIngredientsJSONSerialization()
    }
    
    private func configureViewController() {
        title = meal.name
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
        
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseID)
    }
    
    
    func getAllIngredientsJSONSerialization() {
        guard let mealID = meal?.id else { return }
        NetworkManager.shared.testIngredients(for: mealID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let ingredients):
                self.mealy = ingredients
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                print(error.failureReason)
                self.presentFRAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    
    func getAllIngredients() {
        showActivityIndicator()
        
        guard let mealID = meal?.id else { return }
        NetworkManager.shared.getAllIngredients(name: mealID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let ingredient):
                self.ingredient = ingredient.first
                self.tableView.reloadDataOnMainThread()
                
            case .failure(let error):
                self.presentFRAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }

} // END OF CLASS


// MARK: - Extensions
extension MealDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID) as! IngredientCell
        let ingredienty = self.ingredientys[indexPath.row]
        cell.set(ingredient: ingredienty)
        
        return cell
    }
    
} // END OF EXTENSION
