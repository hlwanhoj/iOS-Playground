//
//  ScrollViewBehaviorViewController.swift
//  Playground
//
//  Created by Ho Lun Wan on 6/3/2023.
//

import UIKit
import Then


class ScrollViewBehaviorViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewInfoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.do {
            $0.contentInset = UIEdgeInsets(top: 30, left: 50, bottom: 30, right: 50)
        }
        updateScrollViewInfo(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateScrollViewInfo(scrollView)
    }
    
    private func updateScrollViewInfo(_ scrollView: UIScrollView) {
        scrollViewInfoLabel.text = """
bounds: \(convertCGRectToString(scrollView.bounds))
contentSize: \(convertCGSizeToString(scrollView.contentSize))
contentOffset: \(convertCGPointToString(scrollView.contentOffset))
contentInset: \(scrollView.contentInset)
adjustedContentInset: \(scrollView.adjustedContentInset)
overscrollOffset: \(convertCGPointToString(scrollView.overscrollOffset))
"""
    }
    
    private func convertCGFloatToString(_ value: CGFloat) -> String {
        NumberFormatter()
            .then {
                $0.maximumFractionDigits = 2
            }
            .string(from: NSNumber(value: value)) ?? ""
    }
    
    private func convertCGSizeToString(_ value: CGSize) -> String {
        "(w:\(convertCGFloatToString(value.width)), h:\(convertCGFloatToString(value.height)))"
    }
    private func convertCGPointToString(_ value: CGPoint) -> String {
        "(x:\(convertCGFloatToString(value.x)), y:\(convertCGFloatToString(value.y)))"
    }
    private func convertCGRectToString(_ value: CGRect) -> String {
        "(x:\(convertCGFloatToString(value.origin.x)), y:\(convertCGFloatToString(value.origin.y)), w:\(convertCGFloatToString(value.size.width)), h:\(convertCGFloatToString(value.size.height)))"
    }

    // MARK: -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateScrollViewInfo(scrollView)
    }
}


public extension UIScrollView {
    /**
     Indicate how much does this scroll view overscrolls.
     
     It is `zero` if the scroll view is not overscrolling.
     `x` is negative when overscroll happens on the left.
     `x` is positive when overscroll happens on the right.
     `y` is negative when overscroll happens at the top.
     `y` is position when overscroll happens at the bottom.
     */
    var overscrollOffset: CGPoint {
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let overscrollLeft: CGFloat = contentOffset.x + contentInset.left
        if overscrollLeft < 0 {
            x = overscrollLeft
        } else {
            let overscrollRight: CGFloat = contentOffset.x + bounds.width - contentSize.width - contentInset.right
            if 0 < overscrollRight {
                x = overscrollRight
            }
        }
        
        let overscrollTop: CGFloat = contentOffset.y + contentInset.top
        if overscrollTop < 0 {
            y = overscrollTop
        } else {
            let overscrollBottom: CGFloat = contentOffset.y + bounds.height - contentSize.height - contentInset.bottom
            if 0 < overscrollBottom {
                y = overscrollBottom
            }
        }
        return CGPoint(x: x, y: y)
    }
}
