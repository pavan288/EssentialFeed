//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Pavan Powani on 23/02/22.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
