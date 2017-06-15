//
//  CartTableView.swift
//  ListViewApp_AndreZhu
//
//  Created by Damen Michael Birtola on 6/14/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class CartTableView: UITableView {
    
    var bookObjects : [ToDoItemMO] = []
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        // Configure the cell...
        var cellItem : ToDoItemMO
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
        
        cellItem = bookObjects[indexPath.row]
        cell.itemImage.image = UIImage(data: cellItem.image as! Data)
        cell.itemText?.text = cellItem.title
        
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
        
        return bookObjects.count
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
    }

}
