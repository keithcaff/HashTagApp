//
//  AppState.swift
//  HashTagApp
//
//  Created by Keith Caffrey on 28/01/2017.
//  Copyright © 2017 Keith Caffrey. All rights reserved.
//
import Foundation

class AppState: NSObject {

  static let sharedInstance = AppState()

  var signedIn = false
  var displayName: String?
  var photoURL: URL?
}
