//
//  MealDetailVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealDetailVC: FRActivityIndicatorVC {
    
    var mealDetail: MealDetail?
    var meal: Meal!
    private let tableView           = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
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
            guard let strongSelf = self else { return }
        
            switch result {
            case .success(let mealDetails):
                strongSelf.mealDetail = mealDetails
                strongSelf.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                strongSelf.presentFRAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
} // END OF CLASS


// MARK: - Extensions
extension MealDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mealDetail?.ingredients?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let ingredients = mealDetail?.ingredients else { return  UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.reuseID) as! IngredientCell
        let ingredient = ingredients[indexPath.row]
        cell.set(mealDetail: ingredient)
        
        return cell
    }
} // END OF EXTENSION
