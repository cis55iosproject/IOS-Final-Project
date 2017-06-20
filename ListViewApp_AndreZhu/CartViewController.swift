//
//  CartViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/12/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    //@IBOutlet weak var cartTableView: CartTableView!
    
    @IBOutlet var Total: UILabel!
    //tax should be 8.5%    @IBOutlet var Tax: UILabel!    
    @IBOutlet var Subtotal: UILabel!
    @IBOutlet weak var cartTableView : UITableView!
    var booksInCart : [CartItemMO] = []
    
    let cellReuseIdentifier = "CartCell"
    
    var fetchResultsController : NSFetchedResultsController<CartItemMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //self.cartTableView.register(TableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)

        
       // cartTableView.delegate = self
       // cartTableView.dataSource = self
        
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
        
        
        let fetchRequest : NSFetchRequest<CartItemMO> = CartItemMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do{
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects{
                    booksInCart = fetchedObjects
                }
            }catch{
                    print(error)
            }
                
        }
        
        
 
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CartCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        // Configure the cell...
        var cellItem : CartItemMO

        cellItem = booksInCart[indexPath.row]
        cell.itemImage?.image = UIImage(data: cellItem.image as! Data)
        cell.itemText?.text = cellItem.title!
        cell.itemAuthor?.text = cellItem.author
        
        print("Cell for row at running for: " + cellItem.title!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        print("Number of rows in section running")
        return booksInCart.count
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int{
        print("Number of sections running")
        return 1
        
    }


    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        cartTableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let eName = controller.fetchRequest.entityName
        if eName == "CartItem"{
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath{
                    cartTableView.insertRows(at: [newIndexPath], with: .left)
                }
            case .delete:
                if let indexPath = indexPath{
                    cartTableView.deleteRows(at: [indexPath], with: .right)
                }
            case .update:
                if let indexPath = indexPath{
                    cartTableView.reloadRows(at: [indexPath], with: .left)
                }
            default:
                cartTableView.reloadData()
            }
            if let fetchedObjects = controller.fetchedObjects{
                booksInCart = fetchedObjects as! [CartItemMO]
            }
        }
        else{
            print("unused class: " + eName!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        cartTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
                
                
                let itemToDelete = self.fetchResultsController.object(at: indexPath)
                
                context.delete(itemToDelete)
                appDelegate.saveContext()
            }

            // handle delete (by removing the data from your array and updating the tableview)
        }
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
