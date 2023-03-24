//
//  LoadCommandType.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2020-04-09.
//  Copyright © 2020/2021 Pinauten GmbH. All rights reserved.
//

import Foundation

public enum LoadCommandType: Equatable {
    private static let map = [
        .SymTab:        0x02,
        .UnixThread:    0x05,
        .DSymTab:       0x0B,
        .Segment64:     0x19,
        .UUID:          0x1B,
        .CodeSignature: 0x1D,
        .DYLDInfo:      0x22,
        .DYLDInfoOnly:  0x80000022,
        .Main:          0x80000028,
        .ChainedFixups: 0x80000034,
        .FilesetEntry:  0x80000035
    ] as KeyValuePairs<LoadCommandType, UInt32>
    
    public var rawValue: UInt32 {
        if let val = LoadCommandType.map[self] {
            return val
        }
        
        guard case .Unknown(let value) = self else {
            fatalError("\(self) not Unknown and not in LoadCommandType.map!")
        }
        
        return value
    }
    
    public static func fromRaw(_ rawValue: UInt32) -> LoadCommandType {
        if let key = LoadCommandType.map.firstKeyOf(value: rawValue) {
            return key
        }
        
        return LoadCommandType.Unknown(rawValue)
    }
    
    case SymTab
    case UnixThread
    case DSymTab
    case Segment64
    case UUID
    case CodeSignature
    case DYLDInfo
    case DYLDInfoOnly
    case Main
    case ChainedFixups
    case FilesetEntry
    
    case Unknown(UInt32)
}
