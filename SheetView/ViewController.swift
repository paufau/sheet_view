//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class ViewController: UIViewController {
    private let sheetView = SheetViewController();
    private var scrollView: UIScrollView = UIScrollView();
    private let mockContent = ScrollableContentViewController()
    
    private var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer();
    
    private func attachSheetView(toView: UIView) {
        toView.addSubview(sheetView.view)
        
        sheetView.view.translatesAutoresizingMaskIntoConstraints = false
        sheetView.modalPresentationStyle = .custom
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        NSLayoutConstraint.activate([
            sheetView.view.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            sheetView.view.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            sheetView.view.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            sheetView.view.heightAnchor.constraint(
                equalToConstant: min(
                    mockContent.view.frame.height,
                    window.frame.height - window.safeAreaInsets.top
                ))
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        
        scrollView = mockContent.scrollView
        scrollView.bounces = false
        
        sheetView.view.addSubview(mockContent.view)
        
        attachSheetView(toView: view)
        
        panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(recognizePanGesture(_:))
        )
        
        panGesture.delegate = self
        
        view.addGestureRecognizer(panGesture)
    }
    
    @objc private func recognizePanGesture(_ gesture: UIPanGestureRecognizer) {
        if scrollView.contentOffset.y <= 0 {
            sheetView.view.transform = CGAffineTransform(
                translationX: 0,
                y: max(gesture.translation(in: gesture.view?.superview).y, 0)
            )
        }
    }
}

extension ViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
}

