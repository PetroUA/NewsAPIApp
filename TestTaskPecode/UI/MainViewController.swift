//
//  MainViewController.swift
//  TestTaskPecode
//
//  Created by Petro on 15.09.2021.
//

import UIKit

class MainViewController: UIViewController {

    let key = "882d2acdf4b940e4b8a038bd81a45a93"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func testButtonTaped(_ sender: Any) {
        let newsAPI = NewsAPI(apiKey: key)
        newsAPI.getSources(category: nil, country: .us) { (result) in
            print("!!!\(result)")
        }
        
    }
}

