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
        let sheetView = SheetViewController(mockContent)
        sheetView.bindScrollView(mockContent.scrollView)
        
        view.addSubview(sheetView.view)
        
//        NSLayoutConstraint.activate([
//            sheetView.view.topAnchor.constraint(equalTo: view.topAnchor),
//            sheetView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            sheetView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            sheetView.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//        ])
    }
    
}



