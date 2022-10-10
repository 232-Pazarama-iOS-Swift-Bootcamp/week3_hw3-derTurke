//
//  FavoriteViewController.swift
//  iTunes Client App
//
//  Created by GÜRHAN YUVARLAK on 10.10.2022.
//

import UIKit
import CoreData

protocol FavoriteProtocol {
    func didTapLikedButton(item: NSManagedObject?)
}

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
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "Education, Fun..."
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavorites()
        
    }
    
    // MARK: - Methods
    // Fetching Favorites in Core Data
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
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoriteCollectionViewCell
        cell.favorite = favorites[indexPath.row]
        //Favorite Protocol Delegate
        cell.favoriteDelegate = self
        cell.title = favorites[indexPath.row].value(forKey: "trackName") as? String
        cell.imageView.downloadImage(from: favorites[indexPath.row].value(forKey: "artworkLarge") as? URL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UISearchResultsUpdating
extension FavoriteViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text?.lowercased(), text.count > 1 {
            favorites = favorites.filter({ favorite in
                return (favorite.value(forKey: "trackName") as! String).lowercased().contains(text.lowercased())

            })
        } else {
            fetchFavorites()
        }
    }
}

// MARK: - FavoriteProtocol
extension FavoriteViewController: FavoriteProtocol {
    func didTapLikedButton(item: NSManagedObject?) {
        removeFavoriteItem(item: item)
    }
    
    
    //Removing Favorite Item in Core Data
    private func removeFavoriteItem(item: NSManagedObject?) {
        guard let item = item else {
            return
        }
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        managedContext?.delete(item)
        
        do {
            try managedContext?.save()
            fetchFavorites()
        } catch {
            let alert = Helpers().alert(title: "Failed", message: "There was a problem adding the item to your favourites! Please try again.")
            present(alert, animated: true)
        }
    }
    
    
}

