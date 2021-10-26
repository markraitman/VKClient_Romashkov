//
//  Session.swift
//  VK_Client_Romashkov
//
//  Created by Mark on 28.02.2021.
//

import UIKit

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var token = ""
    var userId = 0
}

