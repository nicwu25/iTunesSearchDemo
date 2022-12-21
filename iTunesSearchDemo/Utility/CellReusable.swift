//
//  CellReusable.swift
//  iTunesSearchDemo
//
//  Created by cm0678 on 2022/12/20.
//

import UIKit

protocol CellReusable {}

extension CellReusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var cellNib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}

extension UITableViewCell: CellReusable {}
extension UITableViewHeaderFooterView: CellReusable {}
extension UICollectionViewCell: CellReusable {}
