//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Pavan Powani on 21/01/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach({ target in
            self.actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach({
                (target as NSObject).perform(Selector($0))
            })
        })
    }
}
