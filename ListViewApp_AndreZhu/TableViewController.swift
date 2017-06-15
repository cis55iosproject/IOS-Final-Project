//
//  TableViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/8/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchResultsUpdating, NSFetchedResultsControllerDelegate,XMLParserDelegate {
    @IBOutlet weak var tableItem: TableViewCell!
    
    var listObjects : [ToDoItemMO] = []
    var searchResults : [ToDoItemMO] = []
    var searchResultsDict = [String: [ToDoItemMO]]()
    var searchResultsTitles = [String]()
    var searchController : UISearchController!
    var searchSettings: SearchSettings!
    var listObjDict = [String: [ToDoItemMO]]()
    var listObjTitles = [String]()
    
    var appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var fetchResultsController : NSFetchedResultsController<ToDoItemMO>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //for reloading the data from scratch
        /*
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItemMO")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        */
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
            print("blah")
            createArrays()
        }
        
        setupSections()
        
        
        //Search settings stuff
        searchSettings = SearchSettings()
        searchSettings.authorSearch = true
        searchSettings.titleSearch = true
        
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            appDel = appDelegate
        }
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
        var currentSearchResults = searchByBoth(searchText: searchText)
        
        searchResults = currentSearchResults
        searchResultsDict = createAlphaDict(objList: searchResults)
        searchResultsTitles = createTitles(objDict: searchResultsDict)
    }
    
    func searchByBoth(searchText: String) -> [ToDoItemMO]{
        var results: [ToDoItemMO]
        let authorSearch = searchSettings.authorSearch
        let titleSearch = searchSettings.titleSearch
        results = listObjects.filter({ (item: ToDoItemMO) ->
            Bool in
            var contains = false
            if authorSearch{
                let titleMatch = item.author?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
                contains = contains || titleMatch != nil
            }
            if titleSearch{
                let titleMatch = item.title?.range(of: searchText, options: String.CompareOptions.caseInsensitive)
                contains = contains || titleMatch != nil
            }
            
            return contains
        })
        
        return results
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let textToSearch = searchController.searchBar.text{
            filterContentForSearchText(searchText: textToSearch)
            tableView.reloadData()
        }
    }
    
    
    func createArrays() {
        let TSVCount = 9
        let TITLE = 0
        let AUTHOR = 1
        let DESC = 8
        let PRICE = 5
        
        

        let fileContents = Bundle.main.path(forResource: "books", ofType: "tsv")
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
            var count = 1
            for var item in itemArr{
                var components = item.components(separatedBy: "\t")
                if components.count == TSVCount{
                /*
                tableItems.append(components[0])
                tableItemDescriptions.append(components[2])
                
                let imagePath = Bundle.main.path(forResource: components[1], ofType: "jpg", inDirectory: "moviepics")
                tableImages.append(UIImage(contentsOfFile: imagePath!)!)
 */
                
                    let newItem = ToDoItemMO(context: context)
                    
                    newItem.title = components[TITLE]
                    newItem.author = components[AUTHOR]
                    newItem.desc = components[DESC]
                    newItem.price = Double(components[PRICE])!
                    newItem.rating = 0.0
                    //let imagePath = Bundle.main.path(forResource: components[1], ofType: "jpg", inDirectory: "moviepics")
                    //newItem.image = NSData(data: UIImagePNGRepresentation(UIImage(contentsOfFile: imagePath!)!)!)
                    newItem.image = NSData(contentsOfFile: "Book " + String(count) + ".png")
                    
                    
                    
                    appDelegate.saveContext()
                    listObjects.append(newItem)
                
                }
            }
        }
        
    }
    /*
    //XML parsing stuff
    let TITLEPOS = 0
    let AUTHORPOS = 1
    let PRICEPOS = 5
    
    
    var currItem: ToDoItemMO = ToDoItemMO(context: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    var colPos = 0
    var rowPos = 0
    var itemTitle = ""
    var itemAuthor = ""
    var itemPrice = ""
    
    func resetXMLInfo(){
        currItem = ToDoItemMO(context: appDel.persistentContainer.viewContext)
        currItem.rating = 0.0
        currItem.image = NSData(contentsOfFile: "Book " + String(rowPos+1) + ".png")
        currItem.desc = ""
        colPos = 0
        itemTitle = ""
        itemAuthor = ""
        itemPrice = ""
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Row"{
            resetXMLInfo()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Data"{
            colPos += 1
        }
        else if elementName == "Row"{
            listObjects.append(currItem)
            appDel.saveContext()
            rowPos += 1
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        addCharacter(nextChar: string, column: colPos)
    }
    
    func addCharacter(nextChar: String, column: Int){
        switch(column){
        case TITLEPOS:
            itemTitle += nextChar
            break
        case AUTHORPOS:
            itemAuthor += nextChar
            break
        case PRICEPOS:
            itemPrice += nextChar
            break
        default:
            break
        }
    }
    
    func pushProperty(column:Int){
        switch(column){
        case TITLEPOS:
            currItem.title = itemTitle
            break
        case AUTHORPOS:
            currItem.author = itemAuthor
            break
        case PRICEPOS:
            currItem.price = Double(itemPrice)!
            break
        default:
            break
        }
    }
 */
    
    
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
