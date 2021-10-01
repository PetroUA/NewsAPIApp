//
//  ActivityIndicator.swift
//  TestTaskPecode
//
//  Created by Petro on 30.09.2021.
//

import UIKit

class ActivityIndicator: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
