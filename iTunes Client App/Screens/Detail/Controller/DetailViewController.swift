//
//  DetailViewController.swift
//  iTunes Client App
//
//  Created by Pazarama iOS Bootcamp on 2.10.2022.
//

import UIKit
import CoreData

protocol DataDelegate {
    func didTapLikedButton()
}

final class DetailViewController: UIViewController{
    var allModel: AllModel? {
        didSet {
            title = allModel?.trackName
            detailView.dataDelegate = self
            detailView.imageView.downloadImage(from: allModel?.artworkLarge)
            detailView.releaseDate = allModel?.releaseDate
            detailView.artistName = allModel?.artistName
            detailView.country = allModel?.country
            detailView.genres = allModel?.genres?.reduce("") { $1 + ", " + $0 }
        }
    }
    
    private let detailView = DetailView()
    
    private var dataModel = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
    
}
// MARK: - DataDelagete
extension DetailViewController: DataDelegate {
    func didTapLikedButton() {
        guard let allModel = allModel else {
            return
        }
        favoriteItemSaved(with: allModel)
    }
    
    //Favorite Item Add Core Data
    private func favoriteItemSaved(with allModel: AllModel) {
        let genres = allModel.genres?.reduce("") { $1 + ", " + $0 }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext) else {
            return
        }
        
        let favoriteItem = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favoriteItem.setValue(allModel.artistName, forKey: "artistName")
        favoriteItem.setValue(allModel.trackName, forKey: "trackName")
        favoriteItem.setValue(allModel.artworkLarge, forKey: "artworkLarge")
        favoriteItem.setValue(allModel.releaseDate, forKey: "releaseDate")
        favoriteItem.setValue(allModel.country, forKey: "country")
        favoriteItem.setValue(genres, forKey: "genres")
        do {
            try managedContext.save()
            let alert = Helpers().alert(title: "Success", message: "The item has been added to your favourites.")
            present(alert, animated: true)
        } catch {
            let alert = Helpers().alert(title: "Failed", message: "There was a problem adding the item to your favourites! Please try again.")
            present(alert, animated: true)
            
        }
    }
}
