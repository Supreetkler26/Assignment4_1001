//
//  AddEditVC.swift
//  Assignment4_1001
//
//  Created by Ravi  on 2023-08-11.
//

import UIKit
import Firebase
import Kingfisher

class AddEditVC: UIViewController {
    
    @IBOutlet var addEditLabel: UILabel!
    
    @IBOutlet var addEditButton: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var movieIDTextField: UITextField!
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var studioTextField: UITextField!
        
    @IBOutlet var mpaTextField: UITextField!
    
    @IBOutlet var criticsTextField: UITextField!
    
    var movie: Movie?
    var movieViewController: FirebaseCRUDVC?
    var movieUpdateCallback: (() -> Void)?
    var selectedImageUrl: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageUrl = selectedImageUrl, let url = URL(string: imageUrl) {
               imageView.kf.setImage(with: url)
           } else {
               imageView.image = UIImage(named: "jersey_image")
           }

        
        if let movie = movie {
            // Editing existing movie
            movieIDTextField.text = "\(movie.movieID)"
            titleTextField.text = movie.title
            studioTextField.text = movie.studio
            mpaTextField.text = movie.mpaRating
            criticsTextField.text = "\(movie.criticsRating)"
            
            addEditLabel.text = "Edit Movie"
            addEditButton.setTitle("Update", for: .normal)
        } else {
            addEditLabel.text = "Add Movie"
            addEditButton.setTitle("Add", for: .normal)
        }
    }
    

    @IBAction func addEditButton(_ sender: Any) {
        
        let constantImage = UIImage(named: "jersey_image")
        imageView.image = constantImage
        
        guard
            let movieIDString = movieIDTextField.text,
            let movieID = Int(movieIDString),
            let title = titleTextField.text,
            let studio = studioTextField.text,
            let mpaRating = mpaTextField.text,
            let criticsRatingString = criticsTextField.text,
            let criticsRating = Double(criticsRatingString) else {
            print("Invalid data")
            return
        }
        
        let db = Firestore.firestore()
        
        if let movie = movie {
            // Update existing movie
            guard let documentID = movie.documentID else {
                print("Document ID not available.")
                return
            }
            
            // Preserve the existing imgURL when updating
            var updatedData: [String: Any] = [
                "movieID": movieID,
                "title": title,
                "studio": studio,
                "mpaRating": mpaRating,
                "criticsRating": criticsRating
            ]
            
            // Only update imgURL if it exists
            if let imgURL = movie.imgURL {
                updatedData["imgURL"] = imgURL
            }
            
            let movieRef = db.collection("movies").document(documentID)
            movieRef.updateData(updatedData) { [weak self] error in
                if let error = error {
                    print("Error updating movie: \(error)")
                } else {
                    print("Movie updated successfully.")
                    self?.dismiss(animated: true) {
                        self?.movieUpdateCallback?()
                    }
                }
            }
        }  else {
            // Add new movie with default image
            let newMovie = [
                "movieID": Int(movieID),
                "title": title,
                "studio": studio,
                "mpaRating": mpaRating,
                "criticsRating": Double(criticsRating),
                "imgURL": "jersey_image"  // Use the name of the default image in the assets
            ] as [String : Any]
            
            var ref: DocumentReference? = nil
            ref = db.collection("movies").addDocument(data: newMovie) { [weak self] error in
                if let error = error {
                    print("Error adding movie: \(error)")
                } else {
                    print("Movie added successfully.")
                    self?.dismiss(animated: true) {
                        self?.movieUpdateCallback?()
                    }
                }
            }
            
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    

}

