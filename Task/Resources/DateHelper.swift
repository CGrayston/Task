//
//  DateHelper.swift
//  Task
//
//  Created by Chris Grayston on 1/30/19.
//  Copyright © 2019 Chris Grayston. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }}
