//
//  DummyViewController.swift
//  Playground
//
//  Created by Ho Lun Wan on 9/2/2023.
//

import UIKit
import Then
import TinyConstraints

class TagListViewController: UIViewController {
    @IBOutlet var scrollContentView: UIView!
    private let tagListView = TagListView()
    
    private let tagListView2 = TagListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollContentView.addSubview(tagListView)
        
        tagListView.do {
            $0.edgesToSuperview()
            $0.backgroundColor = .systemRed.withAlphaComponent(0.1)
        }
    }
    
    @IBAction func onTapAddLabelButton(_ sender: UIButton) {
        let label = UILabel().then {
            $0.text = "XXXXXX"
        }
        tagListView.addTagView(label)
    }
    
    @IBAction func onTapAddLongLabelButton(_ sender: UIButton) {
        let label = UILabel().then {
            $0.text = "YYYYYYYYYYYYYYYYYY"
        }
        tagListView.addTagView(label)
    }
    
    @IBAction func onTapAddVeryLongLabelButton(_ sender: UIButton) {
        let label = UILabel().then {
            $0.numberOfLines = 0
            $0.text = "ZZZZZZZZZZZZZZZZZZ ZZZZZZZZZZZZZZZZZZ ZZZZZZZZZZZZZZZZZZ"
        }
        tagListView.addTagView(label)
    }
    
    @IBAction func onTapAddViewWithRandomHeightButton(_ sender: UIButton) {
        let height: Int = .random(in: 30...80)
        let hue: CGFloat = .random(in: 0...1)
        let view = UIView().then {
            $0.backgroundColor = UIColor(hue: hue, saturation: 0.7, brightness: 1, alpha: 1)
            $0.width(60)
            $0.height(CGFloat(height))
        }
        tagListView.addTagView(view)
    }
    
    @IBAction func onAlignmentSegmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                tagListView.alignment = .start
            case 1:
                tagListView.alignment = .center
            default:
                tagListView.alignment = .end
        }
    }
    
    @IBAction func onCrossAxisAlignmentSegmentValueChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                tagListView.crossAxisAlignment = .start
            case 1:
                tagListView.crossAxisAlignment = .center
            default:
                tagListView.crossAxisAlignment = .end
        }
    }
    
    @IBAction func onSpacingSliderValueChange(_ sender: UISlider) {
        tagListView.spacing = CGFloat(sender.value)
    }
    
    @IBAction func onRowSpacingSliderValueChange(_ sender: UISlider) {
        tagListView.rowSpacing = CGFloat(sender.value)
    }
}

//

private class Row {
    struct ViewAndSize {
        let view: UIView
        let size: CGSize
    }
    
    private let maxLayoutWidth: CGFloat
    let spacing: CGFloat
    private var remainingLayoutWidth: CGFloat
    private(set) var viewAndSizes: [ViewAndSize] = []
    /// Row width
    private(set) var width: CGFloat = 0
    /// Row height
    private(set) var height: CGFloat = 0
    
    init(maxLayoutWidth: CGFloat, spacing: CGFloat) {
        self.maxLayoutWidth = maxLayoutWidth
        self.spacing = spacing
        remainingLayoutWidth = maxLayoutWidth
    }
    
    @discardableResult
    func addViewAndSize(view: UIView, size: CGSize) -> Bool {
        if remainingLayoutWidth < size.width { return false }
        
        // Update width
        width += size.width
        if !viewAndSizes.isEmpty {
            width += spacing
        }
        // Update height
        height = max(height, size.height)
        viewAndSizes.append(ViewAndSize(view: view, size: size))
        // Minus spacing as new view always has spacing before it
        remainingLayoutWidth = maxLayoutWidth - width - spacing
        return true
    }
}

class TagListView: UIView {
    enum Alignment: CGFloat {
        case start = 0, center = 0.5, end = 1
    }
    
    private typealias ViewAndSize = (view: UIView, size: CGSize)
    
    private var preferredMaxLayoutWidth: CGFloat = 0
    private var tagViews: [UIView] = []
    private var frameForTagView: [UIView: CGRect] = [:]
    private(set) var numberOfRows: Int = 0
    /// How the children within a row should be placed in the main axis.
    var alignment: Alignment = .start {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    /// How the children within a row should be aligned relative to each other in the cross axis.
    var crossAxisAlignment: Alignment = .start {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    /// How much space to place between children in a row in the main axis.
    var spacing: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    /// How much space to place between the rows themselves in the cross axis.
    var rowSpacing: CGFloat = 0 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }

    override class var requiresConstraintBasedLayout: Bool {
        true
    }
    
    override func layoutSubviews() {
        if preferredMaxLayoutWidth != frame.width {
            preferredMaxLayoutWidth = frame.width
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }

        super.layoutSubviews()
        
        for (view, frame) in frameForTagView {
            view.frame = frame
        }
    }
    
    override var intrinsicContentSize: CGSize {
        numberOfRows = 0
        frameForTagView = [:]
        if preferredMaxLayoutWidth == 0 || tagViews.isEmpty {
            return super.intrinsicContentSize
        }

        numberOfRows = 1
        var row = Row(maxLayoutWidth: preferredMaxLayoutWidth, spacing: spacing)
        var height: CGFloat = 0
        let layoutViewsInRow: (Row) -> Void = { row in
            var xOffset: CGFloat = (self.preferredMaxLayoutWidth - row.width) * self.alignment.rawValue
            if self.numberOfRows > 1 {
                height += self.rowSpacing
            }
            for viewAndSize in row.viewAndSizes {
                var yOffset: CGFloat = (row.height - viewAndSize.size.height) * self.crossAxisAlignment.rawValue
                self.frameForTagView[viewAndSize.view] = CGRect(origin: CGPoint(x: xOffset, y: height + yOffset), size: viewAndSize.size)
                xOffset += (viewAndSize.size.width + row.spacing)
            }
            self.numberOfRows += 1
            height += row.height
        }
        for view in tagViews {
            let viewSize = view.systemLayoutSizeFitting(CGSize(width: preferredMaxLayoutWidth, height: .infinity), withHorizontalFittingPriority: .fittingSizeLevel, verticalFittingPriority: .fittingSizeLevel)
            
            if !row.addViewAndSize(view: view, size: viewSize) {
                if !row.viewAndSizes.isEmpty {
                    // Layout views in completed row
                    layoutViewsInRow(row)
                    // Create a new row
                    row = Row(maxLayoutWidth: preferredMaxLayoutWidth, spacing: spacing)
                }
                
                if preferredMaxLayoutWidth < viewSize.width {
                    // Special handling for wide view
                    if self.numberOfRows > 1 {
                        height += self.rowSpacing
                    }
                    view.frame = CGRect(
                        origin: CGPoint(x: 0, y: height),
                        size: CGSize(width: preferredMaxLayoutWidth, height: viewSize.height))
                    numberOfRows += 1
                    height += viewSize.height
                } else {
                    // Add the view in new row
                    row.addViewAndSize(view: view, size: viewSize)
                }
            }
        }
        
        if !row.viewAndSizes.isEmpty {
            layoutViewsInRow(row)
        }

        return CGSize(width: preferredMaxLayoutWidth, height: height)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        preferredMaxLayoutWidth = targetSize.width
        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        preferredMaxLayoutWidth = 0
        return size
    }
    
    //
    
    func addTagView(_ view: UIView) {
        tagViews.append(view)
        addSubview(view)
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
    
    func removeTagView(_ view: UIView) {
        tagViews.removeAll(where: { $0 == view })
        view.removeFromSuperview()
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
}
