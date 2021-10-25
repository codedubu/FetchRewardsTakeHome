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
    
    let scrollView          = UIScrollView()
    let contentView         = UIView()

    let instructionLabel    = FRBodyLabel(textAlignment: .left)
    let youTubeButton       = FRButton(backgroundColor: .systemRed, title: Title.ytlink, cornerRadius: 14)
    let sourceButton        = FRButton(backgroundColor: .systemGreen, title: Title.sourcelink, cornerRadius: 14)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureScrollView()
        configureUIElements()
        getAllInstructions()
        configureButtons()
    }

    
    private func configureViewController() {
        title                   = Title.instructions
        view.backgroundColor    = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.pinToEdges(of: view)
        contentView.pinToEdges(of: scrollView)
    }
    

    private func configureUIElements() {
        contentView.addSubviews(instructionLabel, youTubeButton, sourceButton)
        
        let padding: CGFloat = 140
        let heightPadding: CGFloat = 44
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 4000),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            instructionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            instructionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            instructionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            youTubeButton.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor),
            youTubeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            youTubeButton.heightAnchor.constraint(equalToConstant: 44),
            youTubeButton.widthAnchor.constraint(equalToConstant: 140),

            sourceButton.topAnchor.constraint(equalTo: youTubeButton.bottomAnchor, constant: 12),
            sourceButton.centerXAnchor.constraint(equalTo: youTubeButton.centerXAnchor),
            sourceButton.heightAnchor.constraint(equalToConstant: heightPadding),
            sourceButton.widthAnchor.constraint(equalToConstant: padding),
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
                self.updateUIOnMainThread(with: mealDetailInstructions)
                self.configureInstructionLabelOnMainThread()

            case .failure(let error):
                self.presentFRErrorAlertOnMainThread(message: error.localizedDescription)
                self.popVCOnMainThread()
            }
        }
    }
    
    
    private func updateUIOnMainThread(with mealDetailInstuctions: MealDetail) {
        DispatchQueue.main.async {
            if mealDetailInstuctions.youtubeLink.isEmpty {
                self.youTubeButton.isHidden = true
            }
            if mealDetailInstuctions.sourceLink.isEmpty {
                self.sourceButton.isHidden = true
            }
            
            self.mealDetailInstruction = mealDetailInstuctions
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
