//
//  SettingsViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/13/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UITableViewController {
    let TITLE = 0
    let AUTHOR = 1
    
    let defaultIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var titleIndexPath : IndexPath! = nil
    var authorIndexPath : IndexPath! = nil
    
    var settingsItem: SearchSettingsMO!
    var settingsDetail: SettingsItem!
    
    var settingsList = [SettingsItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        titleIndexPath = IndexPath(row: TITLE, section: 0)
        authorIndexPath = IndexPath(row: AUTHOR, section: 0)
        
        //hard coded settings item since theres only one needed (currently)
        let options = ["Title (Default)", "Author"]
        let title = "Search By"
        var settingsItem = SettingsItem(settingsOptions: options, settingsType: "", settingsTitle: title)
        
        settingsList.append(settingsItem)
        setDefault()
        reloadCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settingsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settingsList[section].optionsList.count
    }
    
    func reloadCells(){
        let titleCell = tableView.cellForRow(at: titleIndexPath)
        titleCell?.accessoryType = settingsItem.title ? .checkmark : .none
        
        let authorCell = tableView.cellForRow(at: authorIndexPath)
        authorCell?.accessoryType = settingsItem.author ? .checkmark : .none
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let cellItem = settingsList[indexPath.section]
        
        cell.title.text = cellItem.optionsList[indexPath.row]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsList[section].title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == TITLE{
            settingsItem.title = !settingsItem.title
        }
        else if indexPath.row == AUTHOR{
            settingsItem.author = !settingsItem.author
        }
        
        setDefault()
        reloadCells()
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            appDelegate.saveContext()
        }
        
    }
    
    func setDefault(){
        if !settingsItem.title && !settingsItem.author{
            //sets default value (to avoid it being possible to search by no categories)
            settingsItem.title = true
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
    }

}
