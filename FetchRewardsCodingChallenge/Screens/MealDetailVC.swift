//
//  MealDetailVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealDetailVC: FRActivityIndicatorVC {
    
    var meal: Meal!
    var mealDetail: MealDetail?
    
    private let mealImageView   = FRMealImageView(frame: .zero)
    private let tableView       = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(mealImageView, tableView)
        configureViewController()
        configureUIElements()
        configureTableView()
        configureTableView()
        getAllMealDetails()
    }
    
    private func configureViewController() {
        title = meal.name
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
        mealImageView.image = UIImage(systemName: "pencil.circle")
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
    
    
    
    func getAllMealDetails() {
        guard let mealID = meal?.id else { return }
        NetworkManager.shared.getAllMealDetails(for: mealID) { [weak self] result in
            guard let strongSelf = self else { return }
        
            switch result {
            case .success(let mealDetails):
                strongSelf.mealDetail = mealDetails
                strongSelf.tableView.reloadDataOnMainThread()
                strongSelf.downloadMealDetailImageOnMainThread()
                
            case .failure(let error):
                print(error.localizedDescription)
                strongSelf.presentFRAlertOnMainThread(title: "Something went wrong", message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
    
    
    func downloadMealDetailImageOnMainThread() {
        DispatchQueue.main.async {
            self.mealImageView.downloadImage(fromURL: self.meal.thumbnail)
        }
    }
    
    
//    private func configureInstructionsButton() {
//        let instructionsButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(nextVC))
//        navigationItem.rightBarButtonItem = instructionsButton
//    }
//    
//    
//    @objc func nextVC() {
//        let destVC = MealInstructionsVC()
//        let navController = UINavigationController(rootViewController: destVC)
//        present(navController, animated: true)
//    }

    
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
