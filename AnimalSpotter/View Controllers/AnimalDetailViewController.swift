//
//  AnimalDetailViewController.swift
//  AnimalSpotter
//
//  Created by Ben Gohlke on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AnimalDetailViewController: UIViewController {
    
    // MARK: - Properties
    var animalName: String!
    var apiController: APIController!
    
    @IBOutlet weak var timeSeenLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImageView: UIImageView!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getDetails()
    }
    
    //MARK: - Private Methods
    private func getDetails() {
        apiController.fetchDetails(for: animalName) { (result) in
            guard let animal = try? result.get() else { return }
            
            DispatchQueue.main.async {
                self.updateViews(with: animal)
            }
            
            // Fetch the image
            self.apiController.fetchImage(at: animal.imageURL) { (result) in
                guard let image = try? result.get() else { return }
                
                DispatchQueue.main.async {
                    self.animalImageView.image = image
                }
            }
        }
    }
    
    private func updateViews(with animal: Animal) {
        title = animal.name
        descriptionLabel.text = animal.description
        coordinatesLabel.text = "lat: \(animal.latitude), long: \(animal.longitude)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        timeSeenLabel.text = dateFormatter.string(from: animal.timeSeen)
    }
}
