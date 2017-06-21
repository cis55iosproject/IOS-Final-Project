//
//  BookAPIHandler.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/19/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class BookAPIHandler: NSObject {
    
    let MAXRESULTS = 20
    
    let NYTAPI = "fdb74175992d4ba7a5cf33d15da8b67e"
    
    let GOOGLEAPI = "&key=AIzaSyD3MrotJnIG40zCSHTzv6sH7PmKdah9yCM"
    let baseURL = "https://www.googleapis.com/books/v1/"
    let TITLE = "?q="
    let BOOK = "volumes"
    let ISBN = "isbn:"
    
    let TOTAL = "totalItems"
    let ITEMS = "items"
    let INFO = "volumeInfo"
    let BOOKTITLE = "title"
    let AUTHOR = "authors"
    let DESC = "description"
    let SALE = "saleInfo"
    let PRICE = "listPrice"
    let PRICE2 = "amount"
    let IMAGE = "imageLinks"
    let IMAGE2 = "thumbnail"
    
    let test = "https://www.googleapis.com/books/v1/"
    
    
    func getDataFromTitle(title: String, completion: @escaping (_ bookData: [[String:Any]]) -> Void) {
        let titleURL = URL(string:baseURL + BOOK + TITLE + title)
        URLSession.shared.dataTask(with: titleURL!) {
            (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    var bookData = [[String:Any]]()
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let items = parsedData[self.ITEMS] as! [[String:Any]]
                    let found = items.count
                    let count = min(self.MAXRESULTS, found)
                    for var i in 0..<count{
                        var currData = [String:Any]()
                        let item = items[i]
                        let info = item[self.INFO] as! [String:Any]
                        
                        currData["title"] = info[self.BOOKTITLE] as! String
                        currData["author"] = info[self.AUTHOR] as! String
                        currData["desc"] = info[self.DESC] as! String
                        
                        let imageHolder = info[self.IMAGE] as! [String:String]
                        let imageLink = imageHolder[self.IMAGE2]
                        currData["image"] = self.imageFromLink(url: imageLink!)
                        
                        let saleInfo = item[self.SALE] as! [String:Any]
                        currData["price"] = (saleInfo[self.PRICE] as! [String:Any])[self.PRICE2] as! Double
                        
                        bookData.append(currData)
                    }
                    completion(bookData)
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()

    }
    
    func getDataFromISBN(isbn: String, completion: @escaping (_ bookData: [[String:Any]]) -> Void) {
        print("startng")
        let bookURL = URL(string: baseURL + BOOK + TITLE + ISBN + isbn)
        URLSession.shared.dataTask(with: bookURL!) {
            (data, response, error) in
            print("finish")
            if error != nil {
                print(error)
            } else {
                do {
                    var bookData = [[String:Any]]()
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let items = parsedData[self.ITEMS] as! [[String:Any]]
                    let found = items.count
                    let count = min(self.MAXRESULTS, found)
                    for var i in 0..<count{
                        var currData = [String:Any]()
                        let item = items[i]
                        let info = item[self.INFO] as! [String:Any]
                        
                        currData["title"] = info[self.BOOKTITLE] as! String
                        currData["author"] = (info[self.AUTHOR] as! [String])[0]
                        currData["desc"] = info[self.DESC] as! String
                        
                        let imageHolder = info[self.IMAGE] as! [String:String]
                        let imageLink = imageHolder[self.IMAGE2]
                        currData["image"] = self.imageFromLink(url: imageLink!)
                        
                        let saleInfo = item[self.SALE] as! [String:Any]
                        currData["price"] = (saleInfo[self.PRICE] as! [String:Any])[self.PRICE2] as! Double
                        
                        bookData.append(currData)
                    }
                    completion(bookData)
                    
                } catch let error as NSError {
                    print(error)
                }
            }

            }.resume()
    }
    
    func bookObjectFromURL(contents: URL){
        URLSession.shared.dataTask(with:contents) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                do {
                    var bookData = [[String:Any]]()
                    let parsedData = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                    let items = parsedData[self.ITEMS] as! [[String:Any]]
                    let found = items.count
                    let count = min(self.MAXRESULTS, found)
                    for var i in 0..<count{
                        var currData = [String:Any]()
                        let item = items[i]
                        let info = item[self.INFO] as! [String:Any]
                        
                        currData["title"] = info[self.BOOKTITLE] as! String
                        currData["author"] = info[self.AUTHOR] as! String
                        currData["desc"] = info[self.DESC] as! String
                        
                        let imageHolder = info[self.IMAGE] as! [String:String]
                        let imageLink = imageHolder[self.IMAGE2]
                        currData["image"] = self.imageFromLink(url: imageLink!)
                        
                        let saleInfo = item[self.SALE] as! [String:Any]
                        currData["price"] = (saleInfo[self.PRICE] as! [String:Any])[self.PRICE2] as! Double
                        
                        bookData.append(currData)
                    }
                    
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
        
    }
    
    func imageFromLink(url: String) -> UIImage{
        let url = URL(string: url)
        var image: UIImage!
        do{
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            image = UIImage(data:data!)
        }
        catch{
            //set image to default
            image = UIImage(named: "noImage")
        }
        return image
    }

}
