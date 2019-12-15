//
//  ViewControllerDebugging.swift
//  WolfViewControllers
//
//  Created by Wolf McNally on 5/18/16.
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
import WolfStrings

extension UIViewController {
    public func printControllerHierarchy() {
        let aliaser = ObjectAliaser()
        var stack = [(controller: UIViewController, level: Int, indent: String)]()

        stack.append((self, 0, ""))
        let frontController = UIViewController.frontViewController

        repeat {
            let (controller, level, indent) = stack.removeLast()

            let joiner = Joiner()

            joiner.append(prefix(for: controller, frontController: frontController))

            controller.children.reversed().forEach { childController in
                stack.append((childController, level + 1, indent + "  |"))
            }

            joiner.append( indent, "\(level)".padded(to: 2) )
            joiner.append(aliaser.name(for: controller))

            if let view = controller.viewIfLoaded {
                joiner.append("view: \(view)")
            } else {
                joiner.append("view: nil")
            }

            if let presentedViewController = controller.presentedViewController {
                if presentedViewController != controller.parent?.presentedViewController {
                    stack.insert((presentedViewController, 0, ""), at: 0)
                    joiner.append("presents:\(aliaser.name(for: presentedViewController))")
                }
            }

            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    joiner.append("presentedBy:\(aliaser.name(for: presentingViewController))")
                }
            }

            print(joiner)
        } while !stack.isEmpty
    }

    private func prefix(for controller: UIViewController, frontController: UIViewController) -> String {
        var prefix: String!

        if prefix == nil {
            for window in UIApplication.shared.windows {
                if let rootViewController = window.rootViewController {
                    if controller == rootViewController {
                        prefix = "🌳"
                    }
                }
            }
        }

        if prefix == nil {
            if let presentingViewController = controller.presentingViewController {
                if presentingViewController != controller.parent?.presentingViewController {
                    prefix = "🎁"
                }
            }
        }

        if prefix == nil {
            prefix = "⬜️"
        }

        prefix = prefix! + (controller == frontController ? "🔵" : "⬜️")

        return prefix
    }
}

public func printRootControllerHierarchy() {
    UIApplication.shared.windows[0].rootViewController?.printControllerHierarchy()
}
#endif
