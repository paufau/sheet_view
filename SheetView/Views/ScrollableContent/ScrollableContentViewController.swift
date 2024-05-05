//
//  ViewController.swift
//  SteetView
//
//  Created by paufau on 03.05.24.
//

import UIKit

class ScrollableContentViewController: UIViewController {
    
    public let scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        _scrollView.backgroundColor = .red
        return _scrollView
    }()
    
    public let contentView: UIView = {
        let _contentView = UIView();
        _contentView.backgroundColor = .purple
        return _contentView
    }()
    
    private let itemsView: [UIView] = {
        var _itemsView: [UIView] = []
        
        for x in 0...1 {
            let iv = UIView()
            iv.layer.borderColor = CGColor.init(red: 1, green: 1, blue: 0, alpha: 1)
            iv.layer.borderWidth = 2
            
            _itemsView.append(iv)
        }
        
        return _itemsView;
    }()
    
    private func attachScrollView(toView: UIView) {
        toView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let heightConstraint = scrollView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor);
        heightConstraint.priority = .defaultHigh
        
        let topConstraint = scrollView.topAnchor.constraint(equalTo: toView.topAnchor);
        topConstraint.priority = .defaultLow
        
        NSLayoutConstraint.activate([
            heightConstraint,
            topConstraint,
            scrollView.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: toView.trailingAnchor)
        ])
    }
    
    private func attachContentView(toView: UIView) {
        toView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: toView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: toView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: toView.widthAnchor),
        ])
    }
    
    private func attachItemsView(toView: UIView) {
        let itemHeight: CGFloat = 300
        
        for i in 0...(itemsView.count - 1) {
            let iv = itemsView[i]
            
            toView.addSubview(iv)
            iv.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iv.topAnchor.constraint(equalTo: i == 0 ? toView.topAnchor : itemsView[i - 1].bottomAnchor),
                iv.leadingAnchor.constraint(equalTo: toView.leadingAnchor),
                iv.trailingAnchor.constraint(equalTo: toView.trailingAnchor),
                iv.widthAnchor.constraint(equalTo: toView.widthAnchor),
                iv.heightAnchor.constraint(equalToConstant: itemHeight)
            ])
        }
        
        NSLayoutConstraint.activate([
            toView.heightAnchor.constraint(equalToConstant: itemHeight * CGFloat(itemsView.count))
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attachContentView(toView: scrollView)
        self.attachItemsView(toView: contentView)
        self.attachScrollView(toView: self.view)
    }
    
}
