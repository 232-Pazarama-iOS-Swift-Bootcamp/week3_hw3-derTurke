//
//  FavoriteViewController.swift
//  iTunes Client App
//
//  Created by GÜRHAN YUVARLAK on 10.10.2022.
//

import UIKit
import CoreData

final class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private let favoriteView = FavoriteView()
    private var favorites = [NSManagedObject]() {
        didSet {
            favoriteView.refresh()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorite"
        view = favoriteView
        favoriteView.setCollectionViewDelegate(self, andDataSource: self)
        
//        let searchController = UISearchController()
//        searchController.searchBar.placeholder = "Education, Fun..."
//        searchController.searchResultsUpdater = self
//        navigationItem.searchController = searchController
        fetchFavorites()
    }
    
    // MARK: - Methods
    private func fetchFavorites() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorite")
        do {
            favorites = try managedContext.fetch(fetchRequest)
        } catch {
            let alert = Helpers().alert(title: "Failed", message: "There was a problem fetching favorite items! Please try again.")
            present(alert, animated: true)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let detailViewController = DetailViewController()
//        detailViewController.allModel = allModel?.results?[indexPath.row]
//        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteCollectionViewCell
        cell.title = favorites[indexPath.row].value(forKey: "trackName") as? String
        cell.imageView.downloadImage(from: favorites[indexPath.row].value(forKey: "artworkLarge") as? URL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchResultsUpdating
/*extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        if let text = searchController.searchBar.text, text.count > 1 {
//            fetchPodcasts(with: text)
//        }
    }
}*/

