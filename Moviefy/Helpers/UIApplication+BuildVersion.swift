//
//  UIApplication+BuildVersion.swift
//  Moviefy
//
//  Created by Nuno Gonçalves on 10/06/2020.
//  Copyright © 2020 Liem Vo. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {

    var applicationVersion: String {

        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    var applicationBuild: String {

        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    var versionBuild: String {

        let version = self.applicationVersion
        let build = self.applicationBuild

        return "\(version)(\(build))"
    }
}
