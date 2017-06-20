//
//  DetailPageViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/10/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class DetailPageViewController: UIViewController {

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemUserRating: UITextView!

    @IBOutlet weak var itemRateButton: UIButton!
    @IBOutlet weak var itemWishlistButton: UIButton!
    
    @IBOutlet weak var itemAuthor: UILabel!
    
    let wLName = "WishlistItem"
    let inWishlistText = "Remove from wishlist"
    let notInWishlistText = "Add to wishlist"
    
    var cameFromWL = false
    var isInWishlist = false
    
    var detailItemMO: ToDoItemMO!
    var detailItem: DetailItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTitle.layer.cornerRadius = 5
        itemDescription.layer.cornerRadius = 5
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if detailItemMO.image == nil{
            print("nil")
        }
        self.itemTitle.text = self.detailItem.title
        self.itemDescription.text = self.detailItem.desc
        self.itemAuthor.text = self.detailItem.author
        self.itemImageView.image = detailItem.image
        
        self.itemUserRating.text = String(self.detailItem.rating)
        
        if cameFromWL{
            isInWishlist = true
            cameFromWL = false
        }
        else{
            isInWishlist = findInWL(item: detailItemMO)
        }
        changeWishlistStatus(isIn: isInWishlist)
        
        //move all stuff off screen for animation
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        
        //animate items on to screen
    }
    @IBAction func changeRating(_ sender: Any) {
        let minRating = 0.0
        let maxRating = 10.0
        
        var rating = Double(itemUserRating.text)!
        rating = min(maxRating, rating)
        rating = max(minRating, rating)
        
        if rating == detailItemMO.rating{
            return
        }
        
        detailItemMO.rating = rating
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            appDelegate.saveContext()
        }
    }
    
    
    @IBAction func wishlistAction(_ sender: Any) {
        
        if(!isInWishlist){
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                var newWLItem = WishlistItemMO(context: context)
                //transfer all properties of the detailItem to the new MO
                newWLItem.author = detailItemMO.author
                newWLItem.title = detailItemMO.title
                newWLItem.desc = detailItemMO.desc
                newWLItem.price = detailItemMO.price
                newWLItem.image = detailItemMO.image
                newWLItem.sectionTitle = detailItemMO.sectionTitle
                newWLItem.rating = detailItemMO.rating
                newWLItem.added = NSDate()
                
                appDelegate.saveContext()
            }
            
            //animation stuff
            
        }
        else{
            deleteFromWL(item: detailItemMO)
        }
        
        changeWishlistStatus(isIn: !isInWishlist)
    }
    
    func setDetail(detail: ToDoItemMO){
        detailItemMO = detail
        let img = UIImage(data: detailItemMO.image as! Data)
        detailItem = DetailItem(itemTitle: detailItemMO.title!,
                                itemDesc: detailItemMO.desc!,
                                itemImg: img!,
                                itemAuthor: detailItemMO.author!,
                                itemPrice: detailItemMO.price,
                                itemRating: detailItemMO.rating)
        
    }
    
    func changeWishlistStatus(isIn: Bool){
        //sets the wishlist button based on @param isIn
        if isIn{
            //is in wishlist button state
            itemWishlistButton.setImage(UIImage(named: "WishListSelected"), for: .normal)
            itemWishlistButton.setTitle(inWishlistText, for: .normal)
        }
        
        else{
            //is not in wishlist button state
            itemWishlistButton.backgroundColor = .white
            itemWishlistButton.setImage(UIImage(named: "WishListHeart"), for: .normal)
            itemWishlistButton.setTitle(notInWishlistText, for: .normal)
        }
        isInWishlist = isIn
        
    }
    
    func findInWL(item:ToDoItemMO) -> Bool{
        
        let fetch : NSFetchRequest<WishlistItemMO> = WishlistItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        var results = [WishlistItemMO]()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            let fetchResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects {
                    results = fetchedObjects
                }
            } catch{
                print(error)
            }
        }
        
        for var result in results{
            if result.title == item.title{
                return true
            }
        }
        
        return false
    }
    
    func deleteFromWL(item:ToDoItemMO){
        let fetch : NSFetchRequest<WishlistItemMO> = WishlistItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetch.sortDescriptors = [sortDescriptor]
        fetch.predicate = NSPredicate(format: "title == \"\(item.title!)\"")
        let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let object = try! context.fetch(fetch)
        context.delete(object.first!)
        do{
            try appDel.saveContext()
        } catch{
            print("delete failed")
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddToCart"{
            let cartVC = segue.destination as! CartViewController
            cartVC.addBookToCart(book: detailItemMO as! CatalogItemMO)
        }
    }
 

}
