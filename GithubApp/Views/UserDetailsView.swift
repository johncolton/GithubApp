//
//  UserDetailsView.swift
//  GithubApp
//
//  Created by John Colton on 5/20/25.
//

import SwiftUI

struct UserDetailsView: View {
  @ObservedObject var viewModel: GithubUsersViewModel
  var body: some View {
    if let user = viewModel.selectedUser {
      VStack {
        AsyncImage(url: URL(string: user.avatarUrl)) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 128, height: 128)
            .clipShape(Circle())
        } placeholder: {
          ProgressView()
            .frame(width: 128, height: 128)
        }
        Text(user.name)
          .fontWeight(.bold)
          .font(.title2)
        Text(user.username)
          .font(.title3)
        HStack {
          Text("\("followers".localized): \(user.followersCount)")
          Text("\("following".localized): \(user.followingCount)")
        }
        Text("repositories".localized)
          .fontWeight(.bold)
          .font(.title2)
          .padding([.top, .leading])
          .frame(maxWidth: .infinity, alignment: .leading)
          
        List(viewModel.repositories ?? [], selection: $viewModel.selectedRepository) { repository in
          NavigationLink(value: repository) {
            repositoryRow(repository: repository)
          }
        }
      }
      .task(id: viewModel.selectedUser?.id) {
        if let _ = viewModel.selectedUser {
          await viewModel.loadRepositories()
        }
      }
    }
  }
  
  @ViewBuilder
  private func repositoryRow(repository: Repository) -> some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading) {
          Text(repository.name)
            .fontWeight(.semibold)
          if let language = repository.language {
            Text(language)
              .font(.subheadline)
          }
        }
        Spacer()
        Text ("\(repository.starCount)  ⭐️")
          .fontWeight(.light)
      }
      if let description = repository.description {
        Text(description)
          .fontWeight(.light)
          .italic()
      }
    }
  }
}

#Preview {
  UserDetailsView(viewModel: .preview)
}
