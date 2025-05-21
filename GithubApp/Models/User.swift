//
//  User.swift
//  GithubApp
//
//  Created by John Colton on 5/26/25.
//

import Foundation

struct User: Decodable, Identifiable, Hashable {
  let id: Int
  let username: String
  let name: String
  let avatarUrl: String
  let followersCount: Int
  let followingCount: Int
  
  enum CodingKeys: String, CodingKey {
    case id
    case username = "login"
    case name
    case avatarUrl = "avatar_url"
    case followersCount = "followers"
    case followingCount = "following"
  }
}
