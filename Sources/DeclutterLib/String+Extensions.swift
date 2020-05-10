//
//  File.swift
//  
//
//  Created by Alexey Blinov on 10/05/2020.
//

import Foundation

extension String {
    public var standardizingPath: String {
        (self as NSString).standardizingPath
    }
}
