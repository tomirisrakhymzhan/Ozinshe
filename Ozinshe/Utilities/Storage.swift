//
//  Storage.swift
//  Ozinshe
//
//  Created by Томирис Рахымжан on 13/06/2024.
//

import Foundation
import UIKit

class Storage {
    public var accessToken: String = ""
    
    static let sharedInstance = Storage()
    private init() {
        // Private initialization to ensure just one instance is created.
    }


}
