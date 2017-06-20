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
    
    let NYTAPI = "fdb74175992d4ba7a5cf33d15da8b67e"
    
    let GOOGLEAPI = "&key=AIzaSyD3MrotJnIG40zCSHTzv6sH7PmKdah9yCM"
    let baseURL = "https://www.googleapis.com/books/v1/"
    let TITLE = "?q="
    let BOOK = "volumes"
    let ISBN = "isbn:"
    
    let test = "https://www.googleapis.com/books/v1/"
    
    func searchByISBN(isbn: String) -> [String:String]{
        let bookURL = baseURL + BOOK + TITLE + ISBN + isbn + GOOGLEAPI
        
        var bookData = [String:String]()
        
        if let result = URL(string: bookURL){
            do{
                return bookObjectFromURL(contents: result)
            }
            catch{
                print("content loading error")
            }
        }
        else{
            print("bad url")
        }
        
        return bookData
    }
    
    func searchByTitle(title: String){
        
    }
    
    func bookObjectFromURL(contents: URL) -> [String:String]{
        var bookData = [String:String]()
        if let data = try? Data(contentsOf: contents) {
            do {
                let parsedData = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                
                //Store response in NSDictionary for easy access
                let dict = parsedData as? NSDictionary
                
                bookData
                
            }
                //else throw an error detailing what went wrong
            catch let error as NSError {
                print("Details of JSON parsing error:\n \(error)")
            }
        }
        return bookData
    }
}
