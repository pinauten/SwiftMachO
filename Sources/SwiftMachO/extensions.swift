//
//  extensions.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2021-12-13.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//

import Foundation
import SwiftUtils

internal extension KeyValuePairs where Key: Equatable {
    subscript(key: Key) -> Value? {
        for v in self {
            if v.key == key {
                return v.value
            }
        }
        
        return nil
    }
}

internal extension KeyValuePairs where Value: Equatable {
    func firstKeyOf(value: Value) -> Key? {
        for v in self {
            if v.value == value {
                return v.key
            }
        }
        
        return nil
    }
}
