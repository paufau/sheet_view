//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class SheetViewController: UIViewController {
    private var childViewController: UIViewController;
    private weak var scrollView: UIScrollView? = nil;
    private var containerView: UIView = UIView();
    private var panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer();
    
    init(_ childView: UIViewController) {
        self.childViewController = childView
        super.init(nibName: nil, bundle: nil)
    }

    init(_ childView: UIViewController, _ scrollView: UIScrollView) {
        self.childViewController = childView
        super.init(nibName: nil, bundle: nil)
        self.bindScrollView(scrollView)
    }
    
    required init?(coder: NSCoder) {
        self.childViewController = UIViewController()
        super.init(nibName: nil, bundle: nil)
    }
    
    public func bindScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.bounces = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        
        modalPresentationStyle = .custom
        
        containerView.addSubview(childViewController.view)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint
        ])
        
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
        
        childViewController.didMove(toParent: self)
        attachPanGestureRecognizer(toView: containerView)
    }
    
    override func viewWillLayoutSubviews() {
        scrollView?.layoutIfNeeded();
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        let heightConstraint = containerView.heightAnchor.constraint(
            lessThanOrEqualToConstant: min(
                scrollView!.contentSize.height,
                window.frame.height - window.safeAreaInsets.top
            ))
        
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightConstraint
        ])
    }
    
    private func attachPanGestureRecognizer(toView: UIView) {
        panGesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(recognizePanGesture(_:))
        )

        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        
        toView.isUserInteractionEnabled = true
        toView.addGestureRecognizer(panGesture)
    }
    
    @objc private func recognizePanGesture(_ gesture: UIPanGestureRecognizer) {
        print("gesture", scrollView!.frame.size)
        
        if scrollView!.contentOffset.y <= 0 {
            childViewController.view.transform = CGAffineTransform(
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
