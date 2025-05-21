//
//  String+Extensions.swift
//  GithubApp
//
//  Created by John Colton on 5/26/25.
//

import Foundation

extension String {
  var localized: String {
    NSLocalizedString(self, comment: "")
  }
}
