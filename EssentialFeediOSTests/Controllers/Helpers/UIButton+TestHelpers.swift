//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Pavan Powani on 21/01/22.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
