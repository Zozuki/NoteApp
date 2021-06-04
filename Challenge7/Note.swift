//
//  Note.swift
//  Challenge7
//
//  Created by MacBook Air on 03.12.2020.
//  Copyright © 2020 MacBook Air. All rights reserved.
//

import UIKit

class Note: NSObject, Codable {
    var text: String
    
    init(text: String) {
        self.text = text
    }
}
