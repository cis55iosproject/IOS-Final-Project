//
//  TestTableViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/20/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class TestTableViewController: UITableViewController {

    var testItem: DetailItem!
    var done: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        done = false
        let testISBN = "0399178570"
        let bookHandler = BookAPIHandler()
        bookHandler.getDataFromISBN(isbn: testISBN, completion: bookSearchDone)
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
        return done ? 1 : 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TableViewCell
        let cellItem = testItem
        cell.itemImage?.image = cellItem?.image
        cell.itemText?.text = cellItem?.title
        cell.itemAuthor?.text = cellItem?.author
        cell.addPrice(newPrice: (cellItem?.price)!)
        

        // Configure the cell...

        return cell
    }
    
    func bookSearchDone(bookData: [[String:Any]]){
        //testing
        done = true
        let testData = bookData[0]
        
        let author = testData["author"] as! String
        let title = testData["title"] as! String
        let desc = testData["desc"] as! String
        let image = testData["image"] as! UIImage
        let price = testData["price"] as! Double
        let rating = 0.0
        
        testItem = DetailItem(itemTitle: title, itemDesc: desc, itemImg: image, itemAuthor: author, itemPrice: price, itemRating: rating)
        
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .left)
        tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
