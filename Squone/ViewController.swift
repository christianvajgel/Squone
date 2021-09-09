//
//  ViewController.swift
//  Squone
//
//  Created by chris on 27/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func loadView() {
        self.view = GameView(frame: UIScreen.main.bounds)
    }


}

