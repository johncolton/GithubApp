//
//  GithubService.swift
//  GithubApp
//
//  Created by John Colton on 5/21/25.
//

import Foundation

protocol GithubService {
  func getUserDetails(usernames: [String]) async throws -> [User]
  func getRepositories(username: String)  async throws -> [Repository]
}

struct GithubAPIService: GithubService {
  func getUserDetails(usernames: [String]) async throws -> [User] {
    var results: [User] = []
    for username in usernames {
      results.append(try await fetchUser(username: username))
    }
    return results
  }
  
  func getRepositories(username: String) async throws -> [Repository] {
    return try await fetchRepositories(username: username)
  }
}

extension GithubAPIService {
  
  private func fetchUser<T: Decodable>(username: String) async throws -> T {
    guard let url = URL(string: "https://api.github.com/users/\(username)") else {
      throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
    }
    let request = makeUrlRequestFor(url: url)
    let (data, _) = try await URLSession.shared.data(for: request)
    let user = try JSONDecoder().decode(T.self, from: data)
    return user
  }
  
  private func fetchRepositories(username: String) async throws -> [Repository] {
    let url = URL(string: "https://api.github.com/users/\(username)/repos")
    let request = makeUrlRequestFor(url: url!)
    let (data, _) = try await URLSession.shared.data(for: request)
    let repos = try JSONDecoder().decode([Repository].self, from: data)
    let nonForkedRepos = repos.filter { !$0.fork }
    return nonForkedRepos
  }
  
  private func makeUrlRequestFor(url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    if let token = loadSecret(named: "GITHUB_TOKEN"), !token.isEmpty {
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
    }
    return request
  }
  
  private func loadSecret(named key: String) -> String? {
    guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
          let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
      return nil
    }
    
    return dict[key] as? String
  }
  
}
