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

    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var itemUserRating: UITextView!
    @IBOutlet weak var itemRatingLabel: UILabel!
    @IBOutlet weak var itemRateButton: UIButton!
    
    var tableVC: TableViewController!
    
    var itemTitleText: String!
    var itemDescriptionText: String!
    var itemImage: UIImage!
    
    var detailItem: ToDoItemMO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemTitle.layer.cornerRadius = 5
        itemDescription.layer.cornerRadius = 5
        
        itemTitle.layer.borderWidth = 3
        itemDescription.layer.borderWidth = 3
        
        itemTitle.layer.borderColor = UIColor.blue.cgColor
        itemDescription.layer.borderColor = UIColor.green.cgColor
        // Do any additional setup after loading the view.
        
        //change objects to preanimation state
        var transformation : CATransform3D = CATransform3DIdentity
        transformation = CATransform3DTranslate(transformation, 400, -400, 0)
        
        itemTitle.layer.transform = transformation
        itemTitle.alpha = 0
        
        itemDescription.layer.transform = transformation
        itemDescription.alpha = 0
        
        itemUserRating.layer.transform = transformation
        itemUserRating.alpha = 0
        
        itemRateButton.layer.transform = transformation
        itemRateButton.alpha = 0
        
        itemRatingLabel.layer.transform = transformation
        itemRatingLabel.alpha = 0


        
        
        UIView.animate(withDuration: 3, animations: {
            self.itemTitle.layer.transform = CATransform3DIdentity
            self.itemTitle.alpha = 1
            
            self.itemDescription.layer.transform = CATransform3DIdentity
            self.itemDescription.alpha = 1
            
            self.itemUserRating.layer.transform = CATransform3DIdentity
            self.itemUserRating.alpha = 1
            
            self.itemRateButton.layer.transform = CATransform3DIdentity
            self.itemRateButton.alpha = 1
            
            self.itemRatingLabel.layer.transform = CATransform3DIdentity
            self.itemRatingLabel.alpha = 1
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.itemTitle.text = self.detailItem.title
        self.itemDescription.text = self.detailItem.desc
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(data: detailItem.image as! Data)!)
        
        self.itemUserRating.text = String(self.detailItem.rating)
        
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
        
        if rating == detailItem.rating{
            return
        }
        
        detailItem.rating = rating
        tableVC.saveChanges()
        

    }
    
    
    
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "AddToCart"{
            let cartVC = segue.destination as! CartViewController
            cartVC.addBookToCart(book: detailItem)
        }
    }
 

}
