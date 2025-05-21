//
//  GithubUsersViewModel.swift
//  GithubApp
//
//  Created by John Colton on 5/21/25.
//

import Foundation

@MainActor
class GithubUsersViewModel: ObservableObject {
  let usernames: [String] = [
    "mattt",
    "twostraws",
    "johnsundell",
    "davedelong",
    "khanlou"
  ]
  @Published var users: [User] = []
  @Published var errorMessage: String?
  @Published var selectedUser: User?
  @Published var repositories: [Repository]?
  @Published var selectedRepository: Repository?
  let githubService: GithubService
  
  var selectedRepoUrl: URL? {
    guard let repoUrl = selectedRepository?.htmlUrl else { return nil }
    return URL(string: repoUrl)
  }
  
  init(githubService: GithubService = GithubAPIService()) {
    self.githubService = githubService
  }
  
  func loadUsers() async {
    do {
      users = try await githubService.getUserDetails(usernames: usernames)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  func loadRepositories() async {
    guard let user = selectedUser else { return }
    repositories = nil
    do {
      repositories = try await githubService.getRepositories(username: user.username)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
}

extension GithubUsersViewModel {
  
    static var preview: GithubUsersViewModel {
        let vm = GithubUsersViewModel(githubService: MockGithubService())
        vm.users = [
          User(id: 1, username: "mattt", name: "Mattt", avatarUrl: "https://avatars.githubusercontent.com/mattt", followersCount: 4, followingCount: 4),
          User(id: 2,username: "twostraws", name: "Paul Hudson", avatarUrl: "https://avatars.githubusercontent.com/twostraws", followersCount: 100, followingCount: 200)
        ]
        vm.selectedUser = vm.users.first
        vm.repositories = [
            Repository(
                id: 1,
                name: "Networking",
                language: "Swift",
                starCount: 4,
                description: "Modern networking library" ,
                htmlUrl: "https://github.com/mattt/networking",
                fork: false
            )
        ]
        return vm
    }
  struct MockGithubService: GithubService {
    func getUserDetails(usernames: [String]) async throws -> [User] {
      [User(id: 1, username: "twostraws", name: "Paul Hudson", avatarUrl: "https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png", followersCount: 40, followingCount: 4)]
    }
    
    func getRepositories(username: String) async throws -> [Repository] {
      [
        Repository(
          id: 1,
          name: "\(username)'s Repo",
          language: "Preview repo for \(username)",
          starCount: 40,
          description: "Swift",
          htmlUrl: "https://github.com/\(username)/repo",
          fork: false
        )
      ]
    }
  }
}
