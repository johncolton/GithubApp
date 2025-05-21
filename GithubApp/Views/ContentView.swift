//
//  ContentView.swift
//  GithubApp
//
//  Created by John Colton on 5/20/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var viewModel = GithubUsersViewModel()
  @State private var columnVisibility: NavigationSplitViewVisibility = .all
  
  var body: some View {
    NavigationSplitView(columnVisibility: $columnVisibility) {
      // User List View
      if let errorMessage = viewModel.errorMessage {
        Text(errorMessage)
          .foregroundColor(.red)
      }
      List(viewModel.users, selection: $viewModel.selectedUser) { user in
        NavigationLink(value: user) {
          userRow(user: user)
        }
      }
      .navigationTitle("users".localized)
      .task {
        await viewModel.loadUsers()
      }
    } content: {  // User Detail View
      if let _ = viewModel.selectedUser {
        UserDetailsView(viewModel: viewModel)
      } else {
        Text("Select a user to view details".localized)
      }
    } detail: {  // WebView
      if let selectedRepoUrl = viewModel.selectedRepoUrl {
        WebView(url: selectedRepoUrl)
          .edgesIgnoringSafeArea(.all)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if let _ = viewModel.selectedUser {
        Text("Select a repository".localized)
      }
    }
    .onChange(of: viewModel.selectedUser) { _, newUser in
      viewModel.selectedRepository = nil
      if newUser != nil {
        // hides user list on iPad after a user is selected
        columnVisibility = .doubleColumn
      }
    }
  }
  
  @ViewBuilder
  private func userRow(user: User) -> some View {
    HStack(spacing: 8) {
      AsyncImage(url: URL(string: user.avatarUrl)) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 64, height: 64)
          .clipShape(Circle())
      } placeholder: {
        ProgressView()
          .frame(width: 64, height: 64)
      }
      Text(user.username)
        .font(.headline)
    }
  }
}

#Preview {
  ContentView()
}
