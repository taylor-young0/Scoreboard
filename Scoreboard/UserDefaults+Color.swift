//
//  UserDefaults+Color.swift
//  Scoreboard
//
//  Created by Taylor Young on 2023-06-10.
//

import Foundation
import SwiftUI

extension UserDefaults {
    func color(forKey key: String) -> Color? {
        let colorData: Data? = data(forKey: key)
        guard let colorData else {
            return nil
        }

        let uiColor: UIColor? = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        guard let uiColor else {
            return nil
        }

        return Color(uiColor)
    }

    func set(_ color: Color, forKey key: String) {
        let colorData = try? NSKeyedArchiver.archivedData(withRootObject: UIColor(color), requiringSecureCoding: false)
        setValue(colorData, forKey: key)
    }
}
