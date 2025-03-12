//
//  CustomSearch.swift
//  SwiftArxiv
//
//  Created by Zabir Raihan on 12/03/2025.
//

import SwiftUI

extension NSSearchField {
//    open override var alignmentRectInsets: NSEdgeInsets {
//        return NSEdgeInsets(top: 2, left: -2, bottom: 2, right: -2)
//    }

    // focus ring to none
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
