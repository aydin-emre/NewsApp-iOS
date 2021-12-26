//
//  Alert.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import UIKit
import EAAlert

class Alert: EAAlert {

    override var positiveButtonTextColor: UIColor {
        get {
            return appColor
        }
        set {}
    }

    override var negativeButtonTextColor: UIColor {
        get {
            return appColor
        }
        set {}
    }

    var posButtonText: String?
    override var positiveButtonText: String {
        get {
            return posButtonText ?? "Evet"
        }
        set {
            posButtonText = newValue
        }
    }

    var negButtonText: String?
    override var negativeButtonText: String {
        get {
            return negButtonText ?? "Hayır"
        }
        set {
            negButtonText = newValue
        }
    }

}
