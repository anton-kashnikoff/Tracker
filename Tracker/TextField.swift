//
//  TextField.swift
//  Tracker
//
//  Created by Антон Кашников on 04.08.2023.
//

import UIKit

final class TextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 41)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}
