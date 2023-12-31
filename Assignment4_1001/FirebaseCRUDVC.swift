//
//  FirebaseCRUDVC.swift
//  Assignment4_1001
//
//  Created by Ravi  on 2023-08-11.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Kingfisher

class FirebaseCRUDVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var movies: [Movie] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        KingfisherManager.shared.defaultOptions = [.fromMemoryCacheOrRefresh]

        fetchMoviesFromFirestore()
        // Do any additional setup after loading the view.
    }
    
    
    func fetchMoviesFromFirestore() {
        let db = Firestore.firestore()
        db.collection("movies").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }

            var fetchedMovies: [Movie] = []

            for document in snapshot!.documents {
                                let data = document.data()
                
                                do {
                                    var movie = try Firestore.Decoder().decode(Movie.self, from: data)
                
                                    movie.documentID = document.documentID
                                    fetchedMovies.append(movie)
                                } catch {
                                    print("Error decoding movie data: \(error)")
                                }
                            }

            DispatchQueue.main.async {
                self.movies = fetchedMovies
                self.tableView.reloadData()
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieTableViewCell

        let movie = movies[indexPath.row]

        cell.titleLabel?.text = movie.title
        cell.studioLabel?.text = movie.studio
        cell.ratingLabel?.text = "\(movie.criticsRating)"
        
//        if let criticsRating = movie.criticsRating {
//                cell.ratingLabel?.text = "\(criticsRating)"
//            } else {
//                cell.ratingLabel?.text = "N/A"
//            }

           if let imageUrl = movie.imgURL, let url = URL(string: imageUrl) {
               cell.thumbView.kf.setImage(with: url)
           } else {
               cell.thumbView.image = UIImage(named: "jersey_image")
           }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "AddEditSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let movie = movies[indexPath.row]
            showDeleteConfirmationAlert(for: movie) { confirmed in
                if confirmed {
                    self.deleteMovie(at: indexPath)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddEditSegue" {
            if let addEditVC = segue.destination as? AddEditVC {
                addEditVC.movieViewController = self
                
                if let indexPath = sender as? IndexPath {
                               let movie = movies[indexPath.row]
                               addEditVC.movie = movie
                               addEditVC.selectedImageUrl = movie.imgURL
                           } else {
                               addEditVC.movie = nil
                               addEditVC.selectedImageUrl = nil
                           }
                addEditVC.movieUpdateCallback = { [weak self] in
                    self?.fetchMoviesFromFirestore()
                }
            }
        }
    }

    func showDeleteConfirmationAlert(for movie: Movie, completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Delete Movie", message: "Are you sure you want to delete this movie?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        })

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        })

        present(alert, animated: true, completion: nil)
    }

    func deleteMovie(at indexPath: IndexPath) {
        let movie = movies[indexPath.row]

        guard let documentID = movie.documentID else {
            print("Invalid document ID")
            return
        }

        let db = Firestore.firestore()
        db.collection("movies").document(documentID).delete { [weak self] error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                DispatchQueue.main.async {
                    print("Movie deleted successfully.")
                    self?.movies.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    @IBAction func addButton(_ sender: Any) {
        performSegue(withIdentifier: "AddEditSegue", sender: nil)
    }
    
    @IBAction func closeButton(_ unwindSegue : UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "unwindToPreviousViewController" {
//            // Prepare data to pass back if needed
//        }
//    }

    
}
