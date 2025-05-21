//
//  File.swift
//  GithubApp
//
//  Created by John Colton on 5/26/25.
//

import Foundation

struct Repository: Decodable, Identifiable, Hashable {
  let id: Int
  let name: String
  let language: String?
  let starCount: Int
  let description: String?
  let htmlUrl: String
  let fork: Bool
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case language
    case starCount = "stargazers_count"
    case description
    case htmlUrl = "html_url"
    case fork
  }
}
