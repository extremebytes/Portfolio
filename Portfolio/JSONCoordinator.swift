//
//  JSONUtility.swift
//  Portfolio
//
//  Created by John Woolsey on 3/3/16.
//  Copyright © 2016 ExtremeBytes Software. All rights reserved.
//


import Foundation


// MARK: - Type Aliases

typealias JSONDictionary = [String: AnyObject]


// MARK: - Protocols

protocol JSONParseable {
   static func forJSON(json: AnyObject) -> Self?
}
