//
//  UITableView+Dequeueing.swift
//  EssentialFeediOS
//
//  Created by Pavan Powani on 24/01/22.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
