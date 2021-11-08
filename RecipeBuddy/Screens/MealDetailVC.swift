//
//  MealDetailVC.swift
//  RecipeBuddy
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealDetailVC: RBActivityIndicatorVC {
    
    var meal: Meal!
    var mealDetail: MealDetail?
    
    private let mealImageView   = RBMealImageView(frame: .zero)
    private let tableView       = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(mealImageView, tableView)
        configureViewController()
        configureUIElements()
        configureTableView()
        configureInstructionsButton()
        getAllMealDetails()
    }
    
    
    private func configureViewController() {
        title = meal.name.capitalized
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureTableView() {
        tableView.frame = view.bounds
        tableView.rowHeight = 64
        tableView.delegate = self
        tableView.dataSource = self
        tableView.removeExcessCells()
        
        tableView.register(IngredientCell.self, forCellReuseIdentifier: IngredientCell.reuseID)
    }
    
    
    private func configureUIElements() {
        mealImageView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mealImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mealImageView.widthAnchor.constraint(equalToConstant: 222),
            mealImageView.heightAnchor.constraint(equalTo: mealImageView.widthAnchor),
            
            tableView.topAnchor.constraint(equalTo: mealImageView.bottomAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func configureInstructionsButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: Title.instructions,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(nextVC))
    }
    
    
    private func getAllMealDetails() {
        guard let mealID = meal?.id else { return }
        showActivityIndicator()
        
        NetworkManager.shared.getAllMealDetails(for: mealID) { [weak self] result in
            guard let self = self else { return }
            self.dismissActivityIndicator()
        
            switch result {
            case .success(let mealDetails):
                self.updateUIOnMainThread(with: mealDetails)
                
            case .failure(let error):
                self.presentRBErrorAlertOnMainThread(message: error.localizedDescription)
                self.popVCOnMainThread()
            }
        }
    }
    
    
    private func updateUIOnMainThread(with mealDetails: MealDetail) {
        DispatchQueue.main.async {
            self.mealDetail = mealDetails
            self.mealImageView.downloadImage(fromURL: self.meal.thumbnail)
            self.tableView.reloadData()
        }
    }
    
    
    @objc func nextVC() {
        let destVC = MealInstructionsVC()
        destVC.meal = meal
        
        let navController = UINavigationController(rootViewController: destVC)
        present(navController, animated: true)
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
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.set(mealDetail: ingredient)
        
        return cell
    }
} // END OF EXTENSION
