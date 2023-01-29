import UIKit

public enum SharedAppearance: Equatable, Withable {
    public struct Layout: Equatable, Withable {
        public var insets: UIEdgeInsets = .zero
        public var width: CGFloat?
        public var height: CGFloat?
        public var centerY: CGFloat?
        public var centerX: CGFloat?
        
        public init(
            insets: UIEdgeInsets = .zero,
            width: CGFloat? = nil,
            height: CGFloat? = nil
        ) {
            self.insets = insets
            self.width = width
            self.height = height
        }
        
        public init(
            size: CGSize,
            insets: UIEdgeInsets = .zero
        ) {
            self.width = size.width
            self.height = size.height
            self.insets = insets
        }
        
    }
    
    public struct Priority: Equatable, Withable {
        public var verticalHuggingPriority: UILayoutPriority?
        public var verticalCompressPriority: UILayoutPriority?
        public var horizontalHuggingPriority: UILayoutPriority?
        public var horizontalCompressPriority: UILayoutPriority?
        
        public init(
            verticalHuggingPriority: UILayoutPriority? = nil,
            verticalCompressPriority: UILayoutPriority? = nil,
            horizontalHuggingPriority: UILayoutPriority? = nil,
            horizontalCompressPriority: UILayoutPriority? = nil
        ) {
            self.verticalHuggingPriority = verticalHuggingPriority
            self.verticalCompressPriority = verticalCompressPriority
            self.horizontalHuggingPriority = horizontalHuggingPriority
            self.horizontalCompressPriority = horizontalCompressPriority
        }
    }
    
    public struct Layer: Equatable, Withable {
        public struct Shadow: Equatable {
            public let offsetX: CGFloat?
            public let offsetY: CGFloat?
            public let color: UIColor?
            public let opacity: Float?
            public let radius: CGFloat?
            
            public init(
                offsetX: CGFloat? = nil,
                offsetY: CGFloat? = nil,
                color: UIColor? = nil,
                opacity: Float? = nil,
                radius: CGFloat? = nil
            ) {
                self.offsetX = offsetX
                self.offsetY = offsetY
                self.color = color
                self.opacity = opacity
                self.radius = radius
            }
        }
        
        public var cornerRadius: CGFloat?
        public var cornersToRound: [UIRectCorner]?
        public var borderWidth: CGFloat?
        public var borderColor: UIColor?
        public var shadow: Shadow?
        public var masksToBounds: Bool?
        
        public init(
            cornerRadius: CGFloat? = nil,
            cornersToRound: [UIRectCorner]? = nil,
            borderWidth: CGFloat? = nil,
            borderColor: UIColor? = nil,
            shadow: Shadow? = nil,
            masksToBounds: Bool? = nil
        ) {
            self.cornerRadius = cornerRadius
            self.cornersToRound = cornersToRound
            self.borderWidth = borderWidth
            self.borderColor = borderColor
            self.shadow = shadow
            self.masksToBounds = masksToBounds
        }
    }
    
    public struct Common: Equatable, Withable {
        public var isUserInteractionEnabled: Bool?
        public var alpha: CGFloat?
        public var contentMode: UIView.ContentMode?
        public var backgroundColor: UIColor?
        public var clipsToBounds: Bool?
        public var isHidden: Bool?
        
        public init(
            isUserInteractionEnabled: Bool? = nil,
            alpha: CGFloat? = nil,
            contentMode: UIView.ContentMode? = nil,
            backgroundColor: UIColor? = nil,
            clipsToBounds: Bool? = nil,
            isHidden: Bool? = nil
        ) {
            self.isUserInteractionEnabled = isUserInteractionEnabled
            self.alpha = alpha
            self.contentMode = contentMode
            self.backgroundColor = backgroundColor
            self.clipsToBounds = clipsToBounds
            self.isHidden = isHidden
        }
    }
}

extension SharedAppearance.Priority {
    public static let flexibleVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .defaultLow,
        verticalCompressPriority: .defaultLow
    )
    
    public static let flexibleHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .defaultLow,
        horizontalCompressPriority: .defaultLow
    )
    
    public static let rigidVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .defaultLow,
        verticalCompressPriority: .defaultLow
    )
    
    public static let rigidHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .defaultLow,
        horizontalCompressPriority: .defaultLow
    )
    
    public static let fillVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .init(249),
        verticalCompressPriority: .required
    )
    
    public static let shrinkVertical = SharedAppearance.Priority(
        verticalHuggingPriority: .required,
        verticalCompressPriority: .init(249)
    )
    
    public static let fillHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .init(249),
        horizontalCompressPriority: .required
    )
    
    public static let shrinkHorizontal = SharedAppearance.Priority(
        horizontalHuggingPriority: .required,
        horizontalCompressPriority: .init(249)
    )
}

extension UIView {
    public func updateConstraintPriority(with priority: SharedAppearance.Priority) {
        if let verticalHuggingPriority = priority.verticalHuggingPriority {
            setContentHuggingPriority(verticalHuggingPriority, for: .vertical)
        }
        if let verticalCompressPriority = priority.verticalCompressPriority {
            setContentCompressionResistancePriority(verticalCompressPriority, for: .vertical)
        }
        if let horizontalHuggingPriority = priority.horizontalHuggingPriority {
            setContentHuggingPriority(horizontalHuggingPriority, for: .horizontal)
        }
        if let horizontalCompressPriority = priority.horizontalCompressPriority {
            setContentCompressionResistancePriority(horizontalCompressPriority, for: .horizontal)
        }
    }
    
    public func updateLayer(with layer: SharedAppearance.Layer) {
        if let cornerRadius = layer.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let cornersToRound = layer.cornersToRound,
           let cornerRadius = layer.cornerRadius {
            roundCorners(radius: cornerRadius, corners: cornersToRound)
        }
        if let borderColor = layer.borderColor {
            self.layer.borderColor = borderColor.cgColor
        }
        if let borderWidth = layer.borderWidth {
            self.layer.borderWidth = borderWidth
        }
        if let masksToBounds = layer.masksToBounds {
            self.layer.masksToBounds = masksToBounds
        }
        
        if let radius = layer.shadow?.radius {
            self.layer.shadowRadius = radius
        }
        if let color = layer.shadow?.color?.cgColor {
            self.layer.shadowColor = color
        }
        if let opacity = layer.shadow?.opacity {
            self.layer.shadowOpacity = opacity
        }
        if layer.shadow?.offsetX != nil || layer.shadow?.offsetY != nil {
            self.layer.shadowOffset = CGSize(
                width: layer.shadow?.offsetX ?? .zero,
                height: layer.shadow?.offsetY ?? .zero
            )
        }
    }
    
    public func updateCommon(with common: SharedAppearance.Common) {
        if let isUserInteractionEnabled = common.isUserInteractionEnabled {
            self.isUserInteractionEnabled = isUserInteractionEnabled
        }
        if let alpha = common.alpha {
            self.alpha = alpha
        }
        if let contentMode = common.contentMode {
            self.contentMode = contentMode
        }
        if let backgroundColor = common.backgroundColor {
            self.backgroundColor = backgroundColor
        }
        if let clipToBounds = common.clipsToBounds {
            self.clipsToBounds = clipToBounds
        }
        if let isHidden = common.isHidden {
            self.isHidden = isHidden
        }
    }
}
