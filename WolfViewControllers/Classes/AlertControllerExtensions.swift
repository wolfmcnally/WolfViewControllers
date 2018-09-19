//
//  AlertControllerExtensions.swift
//  WolfViewControllers
//
//  Created by Wolf McNally on 5/24/16.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#if canImport(UIKit)
    import UIKit
#endif

#if os(iOS) || os(tvOS)
    extension UIAlertController {
        /// This is a hack to set the accessibilityIdentifier attribute of a button created by a UIAlertAction on a UIAlertController. It is coded conservatively so as not to crash if Apple changes the view hierarchy of UIAlertController.view at some future date.
        public func setAction(identifier: String?, at index: Int) {
            guard let identifier = identifier else { return }
            let collectionViews: [UICollectionView] = view.descendantViews()
            if collectionViews.count > 0 {
                let collectionView = collectionViews[0]
                if let cell /* :_UIAlertControllerCollectionViewCell */ = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                    if cell.subviews.count > 0 {
                        let subview /* :UIView */ = cell.subviews[0]
                        if subview.subviews.count > 0 {
                            let actionView /* :_UIAlertControllerActionView */ = subview.subviews[0]
                            actionView.accessibilityIdentifier = identifier
                        }
                    }
                }
            }
        }

        public func setAction(accessibilityIdentifiers identifiers: [String]) {
            for index in 0..<actions.count {
                setAction(identifier: identifiers[index], at: index)
            }
        }
    }
#endif
