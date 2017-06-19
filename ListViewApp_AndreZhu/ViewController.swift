//
//  ViewController.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/8/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var welcomeText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeText.text = "Thank you for viewing our store.\n\nProgrammers: Andre Zhu and Damon Birtola\nDesigners: Robbyn Blumenschein and Anglea\n\n The tabs below will take you to the catolog of books, the wishlist and the cart."
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

