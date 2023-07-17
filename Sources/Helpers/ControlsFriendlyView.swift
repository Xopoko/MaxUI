import UIKit

/*
 Problem: Default UIScrollView implementation delays touches for UIControl (incl. UIButton)
 and don't allow to scroll if any UIControl begins receiving touches.
 
 So control highlighting looks ugly and scroll can be interrupted
 To fix that subclasses below overrides this behaviour
 */

/// A custom `UIScrollView` subclass that provides a controls-friendly scrolling experience.
/// The class is designed to allow `UIControl` objects inside the scroll view to be highlighted immediately
/// without delay, while still allowing the scroll view to be draggable.
open class ControlsFriendlyScrollView: UIScrollView {

    /// Initializes and returns a newly allocated scroll view object with the specified frame.
    ///
    /// - Parameter frame: The frame rectangle for the scroll view, measured in points. The origin of the frame is relative to the superview in which you plan to add it.
    override public init(frame: CGRect) {
        super.init(frame: frame)
        delaysContentTouches = false
    }

    /// Initializes and returns a newly allocated view object with the data stored in the unarchiver object.
    ///
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Determines whether the receiver should cancel the touch events in the specified view.
    ///
    /// - Parameter view: The view that the touch event sequence is in.
    /// - Returns: `true` to cancel the touch events in `view`, `false` otherwise.
    ///
    /// This method is combined with `delaysContentTouches = false` to allow `UIControl` objects inside the scroll view to be highlighted immediately without delay, while still allowing the scroll view to be draggable.
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

/// A ControlsFriendlyCollectionView is a subclass of UICollectionView that delays content touches.
///
/// This class is designed to provide a more responsive feel to the user interactions with collection view items.
///
/// - Note: The content touches are delayed to give the user more time to interact with the items.
open class ControlsFriendlyCollectionView: UICollectionView {

    /// Initializes and returns a newly allocated collection view object with the specified frame and layout.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the collection view, measured in points.
    ///   - layout: The layout object to associate with the collection view.
    override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delaysContentTouches = false
    }

    /// Initializes and returns a newly allocated view object with the data stored in the unarchiver object.
    ///
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Combined with `delaysContentTouches = false`
    /// All `UIControlls` inside collection will be highlighted without delay, but will not prevent dragging
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}

open class ControlsFriendlyTableView: UITableView {

    /// Initializes and returns a newly allocated table view object with a specified frame and style.
    ///
    /// - Parameters:
    ///   - frame: The frame rectangle for the collection view, measured in points.
    ///   - style: A constant that specifies the style of the table view.
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        delaysContentTouches = false
    }

    /// Initializes and returns a newly allocated view object with the data stored in the unarchiver object.
    ///
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Combined with `delaysContentTouches = false`
    /// All `UIControlls` inside collection will be highlighted without delay, but will not prevent dragging
    override public func touchesShouldCancel(in view: UIView) -> Bool {
        return true
    }
}
