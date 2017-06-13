//
//  TableViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/8/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableItem: TableViewCell!
    
    var listObjects : [ToDoItemMO] = []
    var searchResults : [ToDoItemMO] = []
    var searchResultsDict = [String: [ToDoItemMO]]()
    var searchResultsTitles = [String]()
    var searchController : UISearchController!
    
    var listObjDict = [String: [ToDoItemMO]]()
    var listObjTitles = [String]()
    
    var fetchResultsController : NSFetchedResultsController<ToDoItemMO>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //for reloading the data from scratch
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemMO")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.searchController.searchBar
        
        let fetchRequest: NSFetchRequest<ToDoItemMO> = ToDoItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            
            do {
                try fetchResultsController.performFetch()
                if let fetchedObjects = fetchResultsController.fetchedObjects {
                    listObjects = fetchedObjects
                }
            } catch{
                print(error)
            }
        }
        
        if listObjects.count == 0{
            createArrays()
        }
        
        setupSections()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //open new page through segue and populate with item data
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if searchController.isActive{
            return searchResultsDict.keys.count
        }
        else{
            return listObjDict.keys.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TableItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell

        // Configure the cell...
        var cellItem : ToDoItemMO
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
        objKey = objTitles[indexPath.section]
        if let objValues = objDict[objKey]{
            cellItem = objValues[indexPath.row]
            cell.itemImage?.image = UIImage(data: cellItem.image as! Data)
            cell.itemText?.text = cellItem.title
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return searchController.isActive ? searchResultsTitles[section] : listObjTitles[section]
    }
    
    
    func addData(newItem: ToDoItemMO){
        listObjects.append(newItem)
    }
    //Search Stuff
    
    func filterContentForSearchText(searchText: String){
        searchResults = listObjects.filter({ (item: ToDoItemMO) ->
            Bool in
            let nameMatch = item.title?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            return nameMatch != nil
        })
        
        searchResultsDict = createAlphaDict(objList: searchResults)
        searchResultsTitles = createTitles(objDict: searchResultsDict)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let textToSearch = searchController.searchBar.text{
            filterContentForSearchText(searchText: textToSearch)
            tableView.reloadData()
        }
    }
    
    
    func createArrays() {
        let fileContents = Bundle.main.path(forResource: "movies", ofType: "txt")
        var text = ""
        do{
            try text = String(contentsOfFile: fileContents!, encoding: String.Encoding.utf8)
        }
        catch{
            print("File not found")
        }
        
        let itemArr = text.components(separatedBy: "\n")
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            for var item in itemArr{
                var components = item.components(separatedBy: " | ")
                if components.count == 3{
                /*
                tableItems.append(components[0])
                tableItemDescriptions.append(components[2])
                
                let imagePath = Bundle.main.path(forResource: components[1], ofType: "jpg", inDirectory: "moviepics")
                tableImages.append(UIImage(contentsOfFile: imagePath!)!)
 */
                
                    let newItem = ToDoItemMO(context: context)
                    
                    newItem.title = components[0]
                    newItem.desc = components[2]
                    
                    let imagePath = Bundle.main.path(forResource: components[1], ofType: "jpg", inDirectory: "moviepics")
                    newItem.image = NSData(data: UIImagePNGRepresentation(UIImage(contentsOfFile: imagePath!)!)!)
                    
                    newItem.rating = 0.0
                    
                    appDelegate.saveContext()
                    listObjects.append(newItem)
                
                }
            }
        }
        
    }
    
    func setupSections(){
        //create items dict
        for var listObject in listObjects{
            let title = listObject.title!
            let listKey = String(title[(title.startIndex)])
            
            if var listValues = listObjDict[listKey]{
                listValues.append(listObject)
                listObjDict[listKey] = listValues
            }
            else{
                listObjDict[listKey] = [listObject]
            }
        }
        
        listObjTitles = [String](listObjDict.keys)
        listObjTitles.sort()
    }
    
    func createAlphaDict(objList: [ToDoItemMO]) -> [String: [ToDoItemMO]]{
        var dictionary = [String: [ToDoItemMO]]()
        for var listObject in objList{
            let title = listObject.title!
            let listKey = String(title[(title.startIndex)])
            
            if var listValues = dictionary[listKey]{
                listValues.append(listObject)
                dictionary[listKey] = listValues
            }
            else{
                dictionary[listKey] = [listObject]
            }
        }
        
        return dictionary
    }
    
    func createTitles(objDict: [String: [ToDoItemMO]]) -> [String]{
        var objTitles = [String](objDict.keys)
        objTitles.sort()
        return objTitles
    }
    
    
    
    
    //CoreData stuff
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            listObjects = fetchedObjects as! [ToDoItemMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func saveChanges(){
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            appDelegate.saveContext()
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
        
        if segue.identifier == "ShowItemDescription" {
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let descriptionVC = segue.destination as! DetailPageViewController
                
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
                objKey = objTitles[indexPath.section]
                
                if let objValues = objDict[objKey]{
                    descriptionVC.detailItem = objValues[indexPath.row]
                    descriptionVC.tableVC = self
                }
            }
        }
    }


}
