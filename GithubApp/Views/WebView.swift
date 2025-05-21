//
//  WebView.swift
//  GithubApp
//
//  Created by John Colton on 5/26/25.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  let url: URL
  
  func makeUIView(context: Context) -> WKWebView {
    return WKWebView()
  }
  
  func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    if webView.url != url {
      webView.load(request)
    }
  }
}
