import UIKit

extension String {
    @discardableResult
    public func attributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }
    
    @discardableResult
    public func font(_ font: UIFont) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.font: font])
    }
    
    @discardableResult
    public func font(_ font: UIFont, forSubstring substring: String) -> NSAttributedString {
        let range = (self as NSString).range(of: substring)
        let mutableAttributedString = NSMutableAttributedString(string: self)
        mutableAttributedString.addAttributes([.font: font], range: range)
        return mutableAttributedString
    }

    @discardableResult
    public func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.paragraphStyle: paragraphStyle])
    }

    @discardableResult
    public func foregroundColor(_ foregroundColor: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.foregroundColor: foregroundColor])
    }

    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.backgroundColor: backgroundColor])
    }

    @discardableResult
    public func ligature(_ ligature: Int) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.ligature: ligature])
    }

    @discardableResult
    public func kern(_ kern: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.kern: kern])
    }

    @discardableResult
    public func tracking(_ tracking: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.tracking: tracking])
    }

    @discardableResult
    public func strikethroughStyle(_ strikethroughStyle: NSUnderlineStyle) -> NSAttributedString {
        NSAttributedString(
            string: self,
            attributes: [.strikethroughStyle: strikethroughStyle.union(.single).rawValue]
        )
    }

    @discardableResult
    public func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> NSAttributedString {
        NSAttributedString(
            string: self,
            attributes: [.underlineStyle: underlineStyle.union(.single).rawValue]
        )
    }

    @discardableResult
    public func strokeColor(_ strokeColor: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.strokeColor: strokeColor])
    }

    @discardableResult
    public func strokeWidth(_ strokeWidth: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.strokeWidth: strokeWidth])
    }

    @discardableResult
    public func shadow(_ shadow: NSShadow) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.shadow: shadow])
    }

    @discardableResult
    public func textEffect(_ textEffect: String) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.textEffect: textEffect])
    }

    @discardableResult
    public func attachment(_ attachment: NSTextAttachment) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.attachment: attachment])
    }

    @discardableResult
    public func link(_ link: URL) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.link: link])
    }

    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.baselineOffset: baselineOffset])
    }

    @discardableResult
    public func underlineColor(_ underlineColor: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.underlineColor: underlineColor])
    }

    @discardableResult
    public func strikethroughColor(_ strikethroughColor: UIColor) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.strikethroughColor: strikethroughColor])
    }

    @discardableResult
    public func obliqueness(_ obliqueness: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.obliqueness: obliqueness])
    }

    @discardableResult
    public func expansion(_ expansion: CGFloat) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.expansion: expansion])
    }

    @discardableResult
    public func writingDirection(_ writingDirection: NSWritingDirection) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.writingDirection: writingDirection])
    }

    @discardableResult
    public func verticalGlyphForm(_ verticalGlyphForm: Int) -> NSAttributedString {
        NSAttributedString(string: self, attributes: [.verticalGlyphForm: verticalGlyphForm])
    }

    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacing = paragraphSpacing
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func headIndent(_ headIndent: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.headIndent = headIndent
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.tailIndent = tailIndent
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = firstLineHeadIndent
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.minimumLineHeight = minimumLineHeight
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.maximumLineHeight = maximumLineHeight
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreakMode
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func baseWritingDirection(
        _ baseWritingDirection: NSWritingDirection
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.baseWritingDirection = baseWritingDirection
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = lineHeightMultiple
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.paragraphSpacingBefore = paragraphSpacingBefore
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func hyphenationFactor(_ hyphenationFactor: Float) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.hyphenationFactor = hyphenationFactor
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    @available(iOS 15.0, *)
    public func usesDefaultHyphenation(_ usesDefaultHyphenation: Bool) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.usesDefaultHyphenation = usesDefaultHyphenation
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func tabStops(_ tabStops: [NSTextTab]) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.tabStops = tabStops
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func defaultTabInterval(_ defaultTabInterval: CGFloat) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.defaultTabInterval = defaultTabInterval
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func textLists(_ textLists: [NSTextList]) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.textLists = textLists
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func allowsDefaultTighteningForTruncation(
        _ allowsDefaultTighteningForTruncation: Bool
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineBreakStrategy(
        _ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy
    ) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakStrategy = lineBreakStrategy
        return NSAttributedString(string: self, attributes: [.paragraphStyle: paragraph])
    }
}

extension NSAttributedString {
    @discardableResult public func font(_ font: UIFont) -> NSAttributedString {
        set([.font: font])
    }

    @discardableResult
    public func paragraphStyle(_ paragraphStyle: NSParagraphStyle) -> NSAttributedString {
        set([.paragraphStyle: paragraphStyle])
    }

    @discardableResult
    public func foregroundColor(_ foregroundColor: UIColor) -> NSAttributedString {
        set([.foregroundColor: foregroundColor])
    }

    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor) -> NSAttributedString {
        set([.backgroundColor: backgroundColor])
    }

    @discardableResult public func ligature(_ ligature: Int) -> NSAttributedString {
        set([.ligature: ligature])
    }

    @discardableResult public func kern(_ kern: CGFloat) -> NSAttributedString {
        set([.kern: kern])
    }

    @discardableResult public func tracking(_ tracking: CGFloat) -> NSAttributedString {
        set([.tracking: tracking])
    }

    @discardableResult
    public func strikethroughStyle(_ strikethroughStyle: NSUnderlineStyle) -> NSAttributedString {
        set([.strikethroughStyle: strikethroughStyle.union(.single).rawValue])
    }

    @discardableResult
    public func underlineStyle(_ underlineStyle: NSUnderlineStyle) -> NSAttributedString {
        set([.underlineStyle: underlineStyle.union(.single).rawValue])
    }

    @discardableResult
    public func strokeColor(_ strokeColor: UIColor) -> NSAttributedString {
        set([.strokeColor: strokeColor])
    }

    @discardableResult
    public func strokeWidth(_ strokeWidth: CGFloat) -> NSAttributedString {
        set([.strokeWidth: strokeWidth])
    }

    @discardableResult public func shadow(_ shadow: NSShadow) -> NSAttributedString {
        set([.shadow: shadow])
    }

    @discardableResult
    public func textEffect(_ textEffect: String) -> NSAttributedString {
        set([.textEffect: textEffect])
    }

    @discardableResult
    public func attachment(_ attachment: NSTextAttachment) -> NSAttributedString {
        set([.attachment: attachment])
    }

    @discardableResult public func link(_ link: URL) -> NSAttributedString {
        set([.link: link])
    }

    @discardableResult
    public func baselineOffset(_ baselineOffset: CGFloat) -> NSAttributedString {
        set([.baselineOffset: baselineOffset])
    }

    @discardableResult
    public func underlineColor(_ underlineColor: UIColor) -> NSAttributedString {
        set([.underlineColor: underlineColor])
    }

    @discardableResult
    public func strikethroughColor(_ strikethroughColor: UIColor) -> NSAttributedString {
        set([.strikethroughColor: strikethroughColor])
    }

    @discardableResult
    public func obliqueness(_ obliqueness: CGFloat) -> NSAttributedString {
        set([.obliqueness: obliqueness])
    }

    @discardableResult
    public func expansion(_ expansion: CGFloat) -> NSAttributedString {
        set([.expansion: expansion])
    }

    @discardableResult
    public func writingDirection(_ writingDirection: NSWritingDirection) -> NSAttributedString {
        set([.writingDirection: writingDirection])
    }

    @discardableResult
    public func verticalGlyphForm(_ verticalGlyphForm: Int) -> NSAttributedString {
        set([.verticalGlyphForm: verticalGlyphForm])
    }

    @discardableResult
    public func lineSpacing(_ lineSpacing: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.lineSpacing = lineSpacing
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func paragraphSpacing(_ paragraphSpacing: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.paragraphSpacing = paragraphSpacing
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func alignment(_ alignment: NSTextAlignment) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.alignment = alignment
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func headIndent(_ headIndent: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.headIndent = headIndent
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func tailIndent(_ tailIndent: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.tailIndent = tailIndent
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.firstLineHeadIndent = firstLineHeadIndent
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func minimumLineHeight(_ minimumLineHeight: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.minimumLineHeight = minimumLineHeight
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func maximumLineHeight(_ maximumLineHeight: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.maximumLineHeight = maximumLineHeight
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.lineBreakMode = lineBreakMode
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func baseWritingDirection(
        _ baseWritingDirection: NSWritingDirection
    ) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.baseWritingDirection = baseWritingDirection
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.lineHeightMultiple = lineHeightMultiple
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.paragraphSpacingBefore = paragraphSpacingBefore
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func hyphenationFactor(_ hyphenationFactor: Float) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.hyphenationFactor = hyphenationFactor
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    @available(iOS 15.0, *)
    public func usesDefaultHyphenation(_ usesDefaultHyphenation: Bool) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.usesDefaultHyphenation = usesDefaultHyphenation
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func tabStops(_ tabStops: [NSTextTab]) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.tabStops = tabStops
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func defaultTabInterval(_ defaultTabInterval: CGFloat) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.defaultTabInterval = defaultTabInterval
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func textLists(_ textLists: [NSTextList]) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.textLists = textLists
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func allowsDefaultTighteningForTruncation(
        _ allowsDefaultTighteningForTruncation: Bool
    ) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
        return set([.paragraphStyle: paragraph])
    }

    @discardableResult
    public func lineBreakStrategy(
        _ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy
    ) -> NSAttributedString {
        let paragraph = mutableParagraph ?? NSMutableParagraphStyle()
        paragraph.lineBreakStrategy = lineBreakStrategy
        return set([.paragraphStyle: paragraph])
    }
}

extension NSAttributedString {
    /// Returns a new NSAttributedString with the given attributes set.
    ///
    /// - Parameter attributes: The attributes to be set on the NSAttributedString.
    /// - Returns: A new NSAttributedString with the given attributes set.
    fileprivate func set(
        _ attributes: [NSAttributedString.Key: Any]
    ) -> NSAttributedString {
        let mutable = NSMutableAttributedString(
            string: string,
            attributes: self.attributes(at: .zero, effectiveRange: nil)
        )
        mutable.addAttributes(
            attributes,
            range: NSRange(location: .zero, length: (string as NSString).length)
        )
        return mutable
    }

    /// Returns the mutable paragraph style of the NSAttributedString.
    ///
    /// - Returns: The mutable paragraph style of the NSAttributedString, or nil if not found.
    fileprivate var mutableParagraph: NSMutableParagraphStyle? {
        let mutable = NSMutableAttributedString(
            string: string,
            attributes: self.attributes(at: .zero, effectiveRange: nil)
        )
        var paragraphStyle: NSParagraphStyle?
        mutable.enumerateAttributes(
            in: NSRange(location: 0, length: mutable.length),
            options: []
        ) { attributes, _, _  in
            paragraphStyle = attributes[.paragraphStyle] as? NSParagraphStyle
        }

        if let paragraphStyle = paragraphStyle {
            let mutableParagraphStyle = paragraphStyle.mutableCopy() as? NSMutableParagraphStyle
            return mutableParagraphStyle
        }
        return nil
    }
}
