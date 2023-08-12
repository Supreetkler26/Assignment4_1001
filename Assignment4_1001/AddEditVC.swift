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

            let movieRef = db.collection("movies").document(documentID)
            movieRef.updateData([
                "movieID": movieID,
                "title": title,
                "studio": studio,
                "mpaRating": mpaRating,
                "criticsRating": criticsRating,
                "imgURL": "jersey_image"
            ]) { [weak self] error in
                if let error = error {
                    print("Error updating movie: \(error)")
                } else {
                    print("Movie updated successfully.")
                    self?.dismiss(animated: true) {
                        self?.movieUpdateCallback?()
                    }
                }
            }
        } else {
            // Add new movie
            let newMovie     = [
                "movieID": Int(movieID),
                "title": title,
                "studio": studio,
//                "year": Int(year),
                "mpaRating": mpaRating,
                "criticsRating": Double(criticsRating)
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
