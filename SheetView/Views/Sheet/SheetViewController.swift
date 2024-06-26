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
    private var underlayView: UIView = {
        let _underlayView = UIView()
        _underlayView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        return _underlayView;
    }()
    private var initialScrollContentOffsetY: CGFloat = 0;
    
    public init(_ childView: UIViewController) {
        self.childViewController = childView
        super.init(nibName: nil, bundle: nil)
        self.setupAccessibility()
    }

    public init(_ childView: UIViewController, _ scrollView: UIScrollView) {
        self.childViewController = childView
        super.init(nibName: nil, bundle: nil)
        self.bindScrollView(scrollView)
        self.setupAccessibility()
    }
    
    private func setupAccessibility() {
        self.modalPresentationStyle = .custom
        self.view.accessibilityViewIsModal = true
        
        self.underlayView.isAccessibilityElement = true
        self.underlayView.accessibilityLabel = "Press to close"
        self.underlayView.accessibilityTraits = .button
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bindScrollView(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
        scrollView.bounces = false
    }
    
    private func attachUnderlayView(toView: UIView) {
        toView.addSubview(underlayView)
        underlayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            underlayView.topAnchor.constraint(equalTo: toView.topAnchor),
            underlayView.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            underlayView.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            underlayView.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
        ])
    }
    
    private func attachContainerView(toView: UIView) {
        toView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let topConstraint = containerView.topAnchor.constraint(equalTo: view.topAnchor)
        topConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topConstraint
        ])
        
        containerView.layoutIfNeeded();
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        // TODO fix rotated height
        let heightConstraint = containerView.heightAnchor.constraint(
            lessThanOrEqualToConstant: min(
                containerView.bounds.height,
                window.bounds.height - window.safeAreaInsets.top
            ))
        
        heightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            heightConstraint
        ])
    }
    
    private func attachChildView(toView: UIView) {
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        
        toView.addSubview(childViewController.view)
        
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childViewController.view.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            childViewController.view.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            childViewController.view.topAnchor.constraint(equalTo: toView.topAnchor),
            childViewController.view.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
        ])
        
        childViewController.didMove(toParent: self)
    }

    public func present(on: UIViewController, animated: Bool = true) {
        guard let superview = on.view as UIView? else { return }
        
        self.willMove(toParent: on)
        on.addChild(self)
        
        superview.addSubview(self.view)

        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: superview.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
        
        self.didMove(toParent: on)
        
        self.containerView.layoutIfNeeded()
        
        if (animated) {
            self.underlayView.alpha = 0
            self.containerView.transform = CGAffineTransform(
                translationX: 0,
                y: self.containerView.bounds.height
            )
            
            UIView.animate(
                withDuration: 0.4,
                animations: {
                    self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.underlayView.alpha = 1
                }
            )
        }
    }
    
    public func dismiss(animated: Bool = true) {
        if (!animated) {
            self.destroy()
            return
        }
        
        UIView.animate(
            withDuration: 0.4,
            animations: {
                self.containerView.transform = CGAffineTransform(
                    translationX: 0,
                    y: self.containerView.bounds.height
                )
                self.underlayView.alpha = 0
            },
            completion: {_ in 
                self.destroy()
            }
        )
    }
    
    private func destroy() {
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(cgColor: CGColor(red: 0, green: 0, blue: 0, alpha: 0))
        
        attachChildView(toView: containerView)
        
        attachUnderlayView(toView: view)
        attachContainerView(toView: view)
        
        attachPanGestureRecognizer(toView: view)
        attachTapGestureRecognizer(toView: underlayView)
    }
    
    private func attachTapGestureRecognizer(toView: UIView) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(recognizeTapGesture))
        toView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func recognizeTapGesture(_ gesture: UITapGestureRecognizer) {
        self.dismiss()
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
        let isOverscrolled = scrollView == nil || scrollView!.contentOffset.y <= 0;
        
        switch(gesture.state) {
        case .began:
            guard scrollView != nil else { return }
            initialScrollContentOffsetY = scrollView!.contentOffset.y;
        case .changed:
            if isOverscrolled {
                containerView.transform = CGAffineTransform(
                    translationX: 0,
                    y: max(gesture.translation(in: gesture.view?.superview).y - self.initialScrollContentOffsetY, 0)
                )
            }
        case .ended:
            let shouldDismissByVelocity = gesture.velocity(in: gesture.view?.superview).y > 2700
            let shouldDismissBySwipeDistance = gesture.translation(in: gesture.view?.superview).y > 100
            
            if ((shouldDismissByVelocity || shouldDismissBySwipeDistance) && isOverscrolled) {
                dismiss()
                return
            }
            restorePosition()
        case .possible:
            return
        case .cancelled:
            return
        case .failed:
            return
        @unknown default:
            return
        }
    }
    
    private func restorePosition() {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            animations: {
                self.containerView.transform = CGAffineTransform(
                    translationX: 0,
                    y: 0
                )
            }
        )
    }
}

extension SheetViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
}
