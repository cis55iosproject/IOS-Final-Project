//
//  WishListController.swift
//  ListViewApp_AndreZhu
//
//  Created by Robbyn Blumenschein on 6/17/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class WishListController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var wishlistItems : [WishlistItemMO] = []
    var fetchResultsController : NSFetchedResultsController<WishlistItemMO>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let fetchRequest: NSFetchRequest<WishlistItemMO> = WishlistItemMO.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects {
                    wishlistItems = fetchedObjects
                }
            } catch{
                print(error)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wishlistItems.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isAtBottom(indexPath: indexPath){
            return tableView.dequeueReusableCell(withIdentifier: "LastItemCell") as! EmptyWishlistCell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "WLCell", for: indexPath) as! TableViewCell

        // Configure the cell...
        let cellItem = wishlistItems[indexPath.row]
        
        cell.itemText?.text = cellItem.title
        cell.itemAuthor?.text = cellItem.author
        cell.addPrice(newPrice: cellItem.price)
        
        cell.itemImage?.image = UIImage(data: cellItem.image! as Data)

        return cell
    }
    
    func isAtBottom(indexPath: IndexPath) -> Bool{
        return indexPath.row >= wishlistItems.count
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //Core Data stuff
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let eName = controller.fetchRequest.entityName
        if eName == "WishlistItem"{
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath{
                    tableView.insertRows(at: [newIndexPath], with: .left)
                }
            case .delete:
                if let indexPath = indexPath{
                    tableView.deleteRows(at: [indexPath], with: .right)
                }
            case .update:
                if let indexPath = indexPath{
                    tableView.reloadRows(at: [indexPath], with: .left)
                }
            default:
                tableView.reloadData()
            }
            if let fetchedObjects = controller.fetchedObjects{
                wishlistItems = fetchedObjects as! [WishlistItemMO]
            }
        }
        else{
            print("unused class: " + eName!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }

    
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowItemDescription" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let descriptionVC = segue.destination as! DetailPageViewController
                
                descriptionVC.setDetail(detail: wishlistItems[indexPath.row])
            }
        }
    }


}
