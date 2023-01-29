import UIKit
import Combine

public struct Text: ComponentViewModelProtocol, DeclaratableTextAppearance {
    public typealias ViewType = TextView
    
    @Binding public var text: String?
    @Binding public var textAppearance = TextView.Appearance()
    @Binding public var attributedText: NSAttributedString?
    
    public init(_ binding: Binding<String?>) {
        self._text = binding
    }
    
    public init(_ nonOptionalBinding: Binding<String>) {
        self.init(Binding(nonOptionalBinding))
    }
    
    public init(_ text: String? = nil) {
        self._text = .dynamic(text)
    }
    
    public init(_ attributedTextBinding: Binding<NSAttributedString?>) {
        self._attributedText = attributedTextBinding
    }
    
    public init(_ nonOptionalAttributedTextBinding: Binding<NSAttributedString>) {
        self.init(Binding(nonOptionalAttributedTextBinding))
    }
    
    public init(_ attributedText: NSAttributedString?) {
        self._attributedText = .dynamic(attributedText)
    }
    
    public init(@TextAttibutedBuilder _ builder: () -> NSAttributedString) {
        self._attributedText = .dynamic(builder())
    }
}

public final class TextView: UILabel {
    private var appearance: Appearance?
    private var cancellables = Set<AnyCancellable>()
}

extension TextView: ReusableView {
    public func configure(with data: Text) {
        data.$text.publisher
            .assign(to: \.text, on: self)
            .store(in: &cancellables)
        
        data.$attributedText.publisher
            .compactMap { $0 }
            .assign(to: \.attributedText, on: self)
            .store(in: &cancellables)
        
        data.$textAppearance.publisher
            .sink { [weak self] appearance in
                self?.updateAppearance(appearance: appearance)
                if let attributedText = data.attributedText { 
                    self?.attributedText = attributedText
                }
            }
            .store(in: &cancellables)
    }
    
    public func prepareForReuse() {
        cancellables.removeAll()
    }
}

// MARK: - Private methods
private extension TextView {
    private func updateAppearance(appearance: Appearance) {
        guard appearance != self.appearance else { return }
        
        font = appearance.font
        textColor = appearance.textColor
        adjustsFontSizeToFitWidth = appearance.adjustsFontSizeToFitWidth
        textAlignment = appearance.textAligment
        numberOfLines = appearance.numberOfLines
        lineBreakMode = appearance.lineBreakMode
        
        self.appearance = appearance
    }
}

extension TextView {
    public struct Appearance: Equatable, Withable {
        public var adjustsFontSizeToFitWidth: Bool
        public var font: UIFont?
        public var textColor: UIColor?
        public var textAligment: NSTextAlignment
        public var numberOfLines: Int
        public var lineBreakMode: NSLineBreakMode
        
        public init(
            adjustsFontSizeToFitWidth: Bool = false,
            font: UIFont? = nil,
            textColor: UIColor? = nil,
            textAligment: NSTextAlignment  = .left,
            numberOfLines: Int  = 1,
            lineBreakMode: NSLineBreakMode = .byTruncatingTail
        ) {
            self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
            self.font = font
            self.textColor = textColor
            self.textAligment = textAligment
            self.numberOfLines = numberOfLines
            self.lineBreakMode = lineBreakMode
        }
    }
}

/// This protocol helps other components that want to use Text's declarative behavior to implement Text apperance. To do this, you need to define the Text appearance in your components.
public protocol DeclaratableTextAppearance {
    var textAppearance: TextView.Appearance { get nonmutating set }
    
    func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self
    func font(_ font: UIFont) -> Self
    func textColor(_ textColor: UIColor) -> Self
    func textAligment(_ textAligment: NSTextAlignment) -> Self
    func numberOfLines(_ numberOfLines: Int) -> Self
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self
}

extension DeclaratableTextAppearance {
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        textAppearance.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        textAppearance.font = font
        return self
    }
    
    @discardableResult
    public func textColor(_ textColor: UIColor) -> Self {
        textAppearance.textColor = textColor
        return self
    }
    
    @discardableResult
    public func textAligment(_ textAligment: NSTextAlignment) -> Self {
        textAppearance.textAligment = textAligment
        return self
    }
    
    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        textAppearance.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        textAppearance.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult
    public func centerMultiline() -> Self {
        textAppearance.textAligment = .center
        textAppearance.numberOfLines = .zero
        return self
    }
    
    @discardableResult
    public func multiline() -> Self {
        textAppearance.numberOfLines = .zero
        return self
    }
}

extension Text: Stylable {
    @discardableResult
    public func style(_ appearance: TextView.Appearance) -> Self {
        self.textAppearance = appearance
        return self
    }
}
