//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mockContent = ScrollableContentViewController()
        let sheetView = SheetViewController(mockContent, mockContent.scrollView)
        
        view.addSubview(sheetView.view)
        addChild(sheetView)
        addChild(mockContent)
        
        sheetView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sheetView.view.topAnchor.constraint(equalTo: view.topAnchor),
            sheetView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sheetView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
//        view.addSubview(mockContent.view)
    }
}


