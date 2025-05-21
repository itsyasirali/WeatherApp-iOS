//
//  LogHelper.swift
//  WeatherApp
//
//  Created by Revolutic on 20/05/2025.
//

import Foundation

func log(_ message: String, tag: String = "CC", file: String = #file, function: String = #function, line: Int = #line) {
#if DEBUG
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("[\(tag)] \(fileName):\(line) \(function) - \(message)")
#endif
}
