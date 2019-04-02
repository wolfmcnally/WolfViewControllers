//
//  ViewControllerExtensions.swift
//  WolfViewControllers
//
//  Created by Wolf McNally on 5/23/16.
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

import UIKit
import WolfLog
import WolfLocale
import WolfConcurrency
import WolfViews
import WolfFoundation

public struct PopoverSource {
    let position: Position
    let permittedArrowDirections: UIPopoverArrowDirection

    init(position: Position, permittedArrowDirections: UIPopoverArrowDirection = .any) {
        self.position = position
        self.permittedArrowDirections = permittedArrowDirections
    }

    public init(view: UIView, rect: CGRect, permittedArrowDirections: UIPopoverArrowDirection = .any) {
        self.init(position: .view(.init(view: view, rect: rect)), permittedArrowDirections: permittedArrowDirections)
    }

    public init(barButtonItem: UIBarButtonItem, permittedArrowDirections: UIPopoverArrowDirection = .any) {
        self.init(position: .barButtonItem(barButtonItem), permittedArrowDirections: permittedArrowDirections)
    }

    public enum Position {
        case view(ViewRect)
        case barButtonItem(UIBarButtonItem)
    }

    public struct ViewRect {
        public let view: UIView
        public let rect: CGRect

        public init(view: UIView, rect: CGRect) {
            self.view = view
            self.rect = rect
        }
    }
}

extension UIViewController {
    public func presentModal(from presentingViewController: UIViewController) -> Self {
        let navigationController = NavigationController(rootViewController: self)
        presentingViewController.present(navigationController, animated: true)
        return self
    }
}

extension UIViewController {
    public func newCancelDismissAction(onCancel: Block? = nil) -> BarButtonItemAction {
        return BarButtonItemAction(item: UIBarButtonItem(barButtonSystemItem: .cancel)) { [unowned self] in
            onCancel?()
            self.dismiss()
        }
    }

    public func newDoneDismissAction(onDone: Block? = nil) -> BarButtonItemAction {
        return BarButtonItemAction(item: UIBarButtonItem(barButtonSystemItem: .done)) { [unowned self] in
            onDone?()
            self.dismiss()
        }
    }

    @objc open func dismiss(completion: Block?) {
        dismiss(animated: true, completion: completion)
    }

    @objc open func dismiss() {
        dismiss(completion: nil)
    }

    #if !os(tvOS)
    public func setBackButtonText(to text: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: text, style: .plain, target: nil, action: nil)
    }

    public func removeBackButtonText() {
        setBackButtonText(to: "")
    }
    #endif
}

public typealias AlertActionBlock = (UIAlertAction) -> Void

public struct AlertAction {
    public let title: String
    public let style: UIAlertAction.Style
    public let identifier: String?
    public let handler: AlertActionBlock?

    public init(title: String, style: UIAlertAction.Style = .default, identifier: String? = nil, handler: AlertActionBlock? = nil) {
        self.title = title
        self.style = style
        self.identifier = identifier
        self.handler = handler
    }

    public static func newCancelAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "Cancel"¶, style: .cancel, identifier: "cancel", handler: handler)
    }

    public static func newOKAction(handler: AlertActionBlock? = nil) -> AlertAction {
        return AlertAction(title: "OK"¶, identifier: "ok", handler: handler)
    }
}

extension UIViewController {
    public func present(alertController: UIAlertController, animated: Bool = true, withIdentifier identifier: String? = nil, buttonIdentifiers: [String?], didAppear: Block? = nil) {
        alertController.view.accessibilityIdentifier = identifier
        present(alertController, animated: animated, completion: didAppear)
//        RunLoop.current.runOnce()
        dispatchOnMain(afterDelay: 0.1) {
            for i in 0..<buttonIdentifiers.count {
                alertController.setAction(identifier: buttonIdentifiers[i], at: i)
            }
        }
    }

    private func presentAlertController(withPreferredStyle style: UIAlertController.Style, title: String?, message: String?, identifier: String? = nil, popoverSource: PopoverSource? = nil, actions: [AlertAction], didAppear: Block?, didDisappear: Block?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        if let popover = alert.popoverPresentationController {
            guard let popoverSource = popoverSource else {
                fatalError("PopoverSpec must be provided.")
            }
            popover.permittedArrowDirections = popoverSource.permittedArrowDirections
            switch popoverSource.position {
            case .view(let sourceView):
                popover.sourceView = sourceView.view
                popover.sourceRect = sourceView.rect
            case .barButtonItem(let barButtonItem):
                popover.barButtonItem = barButtonItem
            }
        }
        var buttonIdentifiers = [String?]()
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: { alertAction in
                didDisappear?()
                action.handler?(alertAction)
            }
            )
            buttonIdentifiers.append(action.identifier)
            alert.addAction(alertAction)
        }
        present(alertController: alert, withIdentifier: identifier, buttonIdentifiers: buttonIdentifiers, didAppear: didAppear)
    }

    public func presentAlert(withTitle title: String, message: String? = nil, identifier: String? = nil, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .alert, title: title, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(withMessage message: String, identifier: String? = nil, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .alert, title: nil, message: message, identifier: identifier, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentSheet(withTitle title: String? = nil, message: String? = nil, identifier: String? = nil, popoverSource: PopoverSource? = nil, actions: [AlertAction], didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlertController(withPreferredStyle: .actionSheet, title: title, message: message, identifier: identifier, popoverSource: popoverSource, actions: actions, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentOKAlert(withTitle title: String, message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlert(withTitle: title, message: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentOKAlert(withMessage message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        presentAlert(withMessage: message, identifier: identifier, actions: [AlertAction.newOKAction()], didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: Error, withTitle title: String, message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        logError(errorType)
        presentOKAlert(withTitle: title, message: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: Error, withMessage message: String, identifier: String? = nil, didAppear: Block? = nil, didDisappear: Block? = nil) {
        logError(errorType)
        presentOKAlert(withMessage: message, identifier: identifier, didAppear: didAppear, didDisappear: didDisappear)
    }

    public func presentAlert(forError errorType: Error, didAppear: Block? = nil, didDisappear: Block? = nil) {
        switch errorType {
        case let error as MessageError:
            presentAlert(forError: error, withMessage: error.message, didAppear: didAppear, didDisappear: didDisappear)
        case let error as LocalizedError:
            presentAlert(forError: error, withMessage: error.localizedDescription, didAppear: didAppear, didDisappear: didDisappear)
        default:
            presentAlert(forError: errorType, withTitle: "Something Went Wrong"¶, message: "Please try again later."¶, identifier: "error", didAppear: didAppear, didDisappear: didDisappear)
        }
    }
}

public protocol HasFrontViewController {
    var frontViewController: UIViewController { get }
}

extension UINavigationController: HasFrontViewController {
    public var frontViewController: UIViewController {
        return topViewController!
    }
}

extension UITabBarController: HasFrontViewController {
    public var frontViewController: UIViewController {
        return selectedViewController!
    }
}

extension UIViewController {
    public static var frontViewController: UIViewController {
        let windowRootController = UIApplication.shared.windows[0].rootViewController!
        var front = windowRootController.presentedViewController ?? windowRootController
        var lastFront: UIViewController? = nil

        while front != lastFront {
            guard let front2 = front as? HasFrontViewController else { break }
            lastFront = front
            front = front2.frontViewController
            front = front.presentedViewController ?? front
        }

        return front
    }

    public func pushViewController(_ vc: UIViewController) {
        navigationController!.pushViewController(vc, animated: true)
    }

    #if !os(tvOS)
    public func pushViewController(_ vc: UIViewController, backItem: UIBarButtonItem) {
        navigationItem.backBarButtonItem = backItem
        pushViewController(vc)
    }

    public func pushViewController(_ vc: UIViewController, backSystemItem: UIBarButtonItem.SystemItem) {
        pushViewController(vc, backItem: UIBarButtonItem(barButtonSystemItem: backSystemItem))
    }
    #endif
}
