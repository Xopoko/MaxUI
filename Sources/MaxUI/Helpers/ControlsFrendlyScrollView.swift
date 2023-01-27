import UIKit

/*
 Problem: Default UIScrollView implementation delays touches for UIControl (incl. UIButton)
 and don't allow to scroll if any UIControl begins receiving touches.
 
 So control highlighting looks ugly and scroll can be interrupted
 To fix that subclasses below overrides this behaviour
 */

open class ControlsFrendlyScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        delaysContentTouches = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Combined with `delaysContentTouches = false`
    /// All `UIControlls` inside collection will be highlighted without delay, but will not prevent dragging
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

open class ControlsFrendlyCollectionView: UICollectionView {
    
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delaysContentTouches = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Combined with `delaysContentTouches = false`
    /// All `UIControlls` inside collection will be highlighted without delay, but will not prevent dragging
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

open class ControlsFrendlyTableView: UITableView {
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delaysContentTouches = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Combined with `delaysContentTouches = false`
    /// All `UIControlls` inside collection will be highlighted without delay, but will not prevent dragging
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
