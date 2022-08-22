//
//  StringExtension.swift
//  iAlbum
//
//  Created by Carlos Osejo on 21/8/22.
//

import Foundation

extension String {
  var localized: String {
        NSLocalizedString(self, comment: " ")
    }
}
