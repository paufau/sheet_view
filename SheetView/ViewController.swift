//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class ViewController: UIViewController {
    private let openSheetButton: UIButton = {
        let _button = UIButton()
        _button.setTitle("Open sheet", for: .normal)
        _button.setTitleColor(.systemBlue, for: .normal)
        _button.accessibilityLabel = "Open sheet"
        return _button
    }()
    
    private let mockContent = ScrollableContentViewController()
    
    @objc private func openSheet() {
        let sheetView = SheetViewController(mockContent, mockContent.scrollView)
        sheetView.present(on: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(openSheetButton)
        openSheetButton.addTarget(self, action: #selector(openSheet), for: .touchUpInside)
        
        openSheetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openSheetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            openSheetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}


