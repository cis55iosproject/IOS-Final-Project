//
//  BookAPIHandler.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/19/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class BookAPIHandler: NSObject {
    
    let NYTAPI = "fdb74175992d4ba7a5cf33d15da8b67e"
    
    let GOOGLEAPI = "&key=AIzaSyD3MrotJnIG40zCSHTzv6sH7PmKdah9yCM"
    let baseURL = "https://www.googleapis.com/books/v1/"
    let TITLE = "?q="
    let BOOK = "volumes"
    let ISBN = "isbn:"
    
    let test = "https://www.googleapis.com/books/v1/"
    
    func searchByISBN(isbn: String){
        let bookURL = baseURL + BOOK + TITLE + ISBN + isbn + GOOGLEAPI
        
        let result = URL(string: bookURL)
    }
    
    func searchByTitle(title: String){
        
    }
}
