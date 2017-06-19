//
//  CartViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/12/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var cartTableView: CartTableView!
    
    @IBOutlet weak var cartTableView : UITableView!
    var booksInCart : [CartItemMO] = []
    
    let cellReuseIdentifier = "CartCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.cartTableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        
        //cartTableView.delegate = self
        //cartTableView.dataSource = self
        
        /*
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            var testItem : ToDoItemMO = ToDoItemMO(context :context)
            testItem.author = "Testauthor"
            testItem.desc = "testDesc"
            //testItem.image = UIImage(data: cellItem)
            testItem.rating = 5
            testItem.title = "TestTitle"
            booksInCart.append(testItem)
        }*/
        
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addBookToCart(book : CatalogItemMO){
        print("Added book to list")
        //cartTableView.reloadData()
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            
            
            var newCartItem = CartItemMO(context: context)
            //transfer all properties of the book to the new MO
            newCartItem.author = book.author
            newCartItem.title = book.title
            newCartItem.desc = book.desc
            newCartItem.price = book.price
            newCartItem.image = book.image
            newCartItem.sectionTitle = book.sectionTitle
            newCartItem.rating = book.rating
            newCartItem.added = NSDate()
            
            booksInCart.append(newCartItem)
            
            
            
            
            appDelegate.saveContext()
        }

        
    }
    
    func saveState(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            
            appDelegate.saveContext()
        }
        
    }
    
    
    
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CartCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        // Configure the cell...
        var cellItem : CartItemMO
        //var objDict : [String:[ToDoItemMO]]
        //var objTitles : [String]
        //var objKey : String
        
        
        /*if searchController.isActive{
         objDict = searchResultsDict
         objTitles = searchResultsTitles
         }
         else{
         objDict = listObjDict
         objTitles = listObjTitles
         }
         objKey = objTitles[indexPath.section]
         if let objValues = objDict[objKey]{
         cellItem = objValues[indexPath.row]
         cell.itemImage?.image = UIImage(data: cellItem.image as! Data)
         cell.itemText?.text = cellItem.title
         }
         */
        
        cellItem = booksInCart[indexPath.row]
        cell.itemImage?.image = UIImage(data: cellItem.image as! Data)
        cell.itemText?.text = cellItem.title!
        cell.itemAuthor?.text = cellItem.author
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        /*
         var objDict : [String:[ToDoItemMO]]
         var objTitles : [String]
         var objKey : String
         
         if searchController.isActive{
         objDict = searchResultsDict
         objTitles = searchResultsTitles
         }
         else{
         objDict = listObjDict
         objTitles = listObjTitles
         }
         
         objKey = objTitles[section]
         if let objValues = objDict[objKey]{
         return objValues.count
         }
         else{
         return 0
         }*/
        print("Code is running")
        return booksInCart.count
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        print("Number of sections running")
        return 1
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
