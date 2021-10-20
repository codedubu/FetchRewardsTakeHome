//
//  MealInstructionsVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealInstructionsVC: UIViewController {
    
    var meal: Meal!
    var mealDetailInstruction: MealDetail?

    let instructionLabel    = FRBodyLabel(textAlignment: .left)
    let youTubeButton       = FRButton(backgroundColor: .systemRed, title: "YouTube Link", cornerRadius: 14)
    let sourceButton        = FRButton(backgroundColor: .systemGreen, title: "Source Link", cornerRadius: 14)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(instructionLabel,youTubeButton,sourceButton)
        configureViewController()
        configureUIElements()
        getAllInstructions()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func configureViewController() {
        title                   = "Instructions"
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    private func configureUIElements() {
        instructionLabel.translatesAutoresizingMaskIntoConstraints     = false
        youTubeButton.translatesAutoresizingMaskIntoConstraints = false
        sourceButton.translatesAutoresizingMaskIntoConstraints  = false
        
        let padding: CGFloat = 140
        let heightPadding: CGFloat = 44
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            instructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            instructionLabel.bottomAnchor.constraint(equalTo: youTubeButton.topAnchor, constant: -14),
            
            youTubeButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor),
            youTubeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            youTubeButton.heightAnchor.constraint(equalToConstant: heightPadding),
            youTubeButton.widthAnchor.constraint(equalToConstant: padding),
            
            sourceButton.topAnchor.constraint(equalTo: youTubeButton.bottomAnchor, constant: 12),
            sourceButton.centerXAnchor.constraint(equalTo: youTubeButton.centerXAnchor),
            sourceButton.heightAnchor.constraint(equalToConstant: heightPadding),
            sourceButton.widthAnchor.constraint(equalToConstant: padding),
            sourceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func getAllInstructions() {
        guard let mealID = meal?.id else { return }
        NetworkManager.shared.getAllMealDetails(for: mealID) { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let mealDetailInstructions):
                strongSelf.mealDetailInstruction = mealDetailInstructions
                strongSelf.fillInstructionLabel()
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fillInstructionLabel() {
        DispatchQueue.main.async {
            let formattedMealDetailInstruction = self.mealDetailInstruction?.instructions.replacingOccurrences(of: "\n", with: "\n\n")
            
            self.instructionLabel.text = formattedMealDetailInstruction
        }
    }
} // END OF CLASS
