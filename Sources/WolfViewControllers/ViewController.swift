//
//  ViewController.swift
//  WolfViewControllers
//
//  Created by Wolf McNally on 6/8/16.
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
import WolfLog
import WolfViews
import WolfNesting
import WolfConcurrency
import WolfFoundation

public typealias ViewControllerBlock = (UIViewController) -> Void

extension LogGroup {
    public static let viewControllerLifecycle = LogGroup("viewControllers")
}

open class ViewController: UIViewController {
    open var navigationItemTitleView: UIView? { return nil }

    public private(set) lazy var activityOverlayView: ActivityOverlayView = {
        let activityView = ActivityOverlayView()
        self.view => [
            activityView
        ]
        activityView.constrainFrameToFrame(priority: .defaultLow)
        return activityView
    }()

    public func newActivity() -> LockerCause {
        return activityOverlayView.newActivity()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        _setup()
    }

    private func _setup() {
        logInfo("init \(self)", group: .viewControllerLifecycle)
        setup()
    }

    deinit {
        //logInfo("deinit \(self)", group: .viewControllerLifecycle)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.debugIdentifier = "\(typeName(of: self)).view"
        build()
        #if !os(tvOS)
            setupNavBarActions()
        #endif
    }

    open func build() {
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        logInfo("awakeFromNib \(self)", group: .viewControllerLifecycle)
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationItem.titleView == nil {
            if let navigationItemTitleView = navigationItemTitleView {
                navigationItem.titleView = navigationItemTitleView
            }
        }
    }

    open override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
    }

    open func setup() { }

    #if !os(tvOS)
    public var leftItemAction: BarButtonItemAction? {
        didSet {
            navigationItem.leftBarButtonItem = leftItemAction?.item
        }
    }

    public var rightItemAction: BarButtonItemAction? {
        didSet {
            navigationItem.rightBarButtonItem = rightItemAction?.item
        }
    }

    private func setupNavBarActions() {
        if let leftItemAction = newLeftItemAction() {
            self.leftItemAction = leftItemAction
        }

        if let rightItemAction = newRightItemAction() {
            self.rightItemAction = rightItemAction
        }
    }

    open func newLeftItemAction() -> BarButtonItemAction? {
        return nil
    }

    open func newRightItemAction() -> BarButtonItemAction? {
        return nil
    }
    #endif
}
#endif
