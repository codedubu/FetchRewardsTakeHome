//
//  MealInstructionsVC.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/19/21.
//

import UIKit

class MealInstructionsVC: FRActivityIndicatorVC {
    
    var meal: Meal!
    var mealDetailInstruction: MealDetail?

    let instructionLabel    = FRBodyLabel(textAlignment: .left)
    let youTubeButton       = FRButton(backgroundColor: .systemRed, title: Title.ytlink, cornerRadius: 14)
    let sourceButton        = FRButton(backgroundColor: .systemGreen, title: Title.sourcelink, cornerRadius: 14)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(instructionLabel,youTubeButton,sourceButton)
        configureViewController()
        configureUIElements()
        configureButtons()
        getAllInstructions()
    }
    
    
    private func configureViewController() {
        title                   = Title.instructions
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    

    private func configureUIElements() {
        instructionLabel.translatesAutoresizingMaskIntoConstraints  = false
        youTubeButton.translatesAutoresizingMaskIntoConstraints     = false
        sourceButton.translatesAutoresizingMaskIntoConstraints      = false
        
        let padding: CGFloat = 140
        let heightPadding: CGFloat = 44
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            instructionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            instructionLabel.bottomAnchor.constraint(equalTo: youTubeButton.topAnchor, constant: -14),
            
            sourceButton.topAnchor.constraint(equalTo: youTubeButton.bottomAnchor, constant: 12),
            sourceButton.centerXAnchor.constraint(equalTo: youTubeButton.centerXAnchor),
            sourceButton.heightAnchor.constraint(equalToConstant: heightPadding),
            sourceButton.widthAnchor.constraint(equalToConstant: padding),
            sourceButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    private func getAllInstructions() {
        guard let mealID = meal?.id else { return }
        showActivityIndicator()
        
        NetworkManager.shared.getAllMealDetails(for: mealID) { [weak self] result in
            guard let self = self else { return }
            self.dismissActivityIndicator()
            
            switch result {
            case .success(let mealDetailInstructions):
                self.mealDetailInstruction = mealDetailInstructions
                self.configureInstructionLabelOnMainThread()
                
            case .failure(let error):
                self.presentFRAlertOnMainThread(title: Alert.wrong, message: error.localizedDescription, buttonTitle: Alert.ok)
            }
        }
    }
    
    
    private func configureInstructionLabelOnMainThread() {
        DispatchQueue.main.async {
            let formattedMealDetailInstruction = self.mealDetailInstruction?.instructions.replacingOccurrences(of: "\n", with: "\n\n")
            
            self.instructionLabel.text = formattedMealDetailInstruction
        }
    }
    
    
    private func configureButtons() {
        youTubeButton.addTarget(self, action: #selector(didTapYoutubeButton), for: .touchUpInside)
        sourceButton.addTarget(self, action: #selector(didTapSourceButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            youTubeButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor),
            youTubeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            youTubeButton.heightAnchor.constraint(equalToConstant: 44),
            youTubeButton.widthAnchor.constraint(equalToConstant: 140),
        ])
  
    }
    
    
    @objc func didTapYoutubeButton() {
        guard let convertedLink = mealDetailInstruction?.youtubeLink else { return }
            presentSafariVC(with: convertedLink)
    }
    
    
    @objc func didTapSourceButton() {
        guard let convertedLink = mealDetailInstruction?.sourceLink else { return }
        presentSafariVC(with: convertedLink)
    }
} // END OF CLASS
