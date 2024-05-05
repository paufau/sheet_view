//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class SheetViewController: UIViewController {
    private var childViewController: UIViewController;
    private var scrollView: UIScrollView? = nil;
    private var containerView: UIView = UIView();
    private var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer();
    
    init(_ childView: UIViewController) {
        self.childViewController = childView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.bounces = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
//        childViewController.willMove(toParent: self)
        
//        childViewController.didMove(toParent: self)
        
        panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(recognizePanGesture(_:))
        )
        
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
        
//        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        modalPresentationStyle = .custom
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        print(childViewController.view.frame)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(
                equalToConstant: min(
                    childViewController.view.frame.height,
                    window.frame.height - window.safeAreaInsets.top
                ))
        ])
        
        containerView.addSubview(childViewController.view)
    }
    
    override func viewWillLayoutSubviews() {

    }
    
    @objc private func recognizePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("gesture")
        
        if scrollView == nil || scrollView!.contentOffset.y <= 0 {
            containerView.transform = CGAffineTransform(
                translationX: 0,
                y: max(gesture.translation(in: gesture.view?.superview).y, 0)
            )
        }
    }
}

extension SheetViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
}
