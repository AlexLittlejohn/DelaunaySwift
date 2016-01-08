//
//  ViewController.swift
//  Triangulation
//
//  Created by Alex Littlejohn on 2016/01/08.
//  Copyright © 2016 zero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let triangleView = TriangleView(frame: view.bounds)
        view.addSubview(triangleView)
    }
}