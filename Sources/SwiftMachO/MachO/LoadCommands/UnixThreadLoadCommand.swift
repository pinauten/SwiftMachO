//
//  UnixThreadLoadCommand.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2021-12-15.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//

import Foundation

open class UnixThreadLoadCommand: LoadCommand {
    public var type: LoadCommandType { .UnixThread }
    public var cmdSize: UInt32
    
    public var threadStates: [(flavor: UInt32, state: Data)] = []
    
    public required init(fromData data: Data) throws {
        guard let type = data.tryGetGeneric(type: UInt32.self) else {
            throw MachOError.ReadError
        }
        
        guard let size = data.tryGetGeneric(type: UInt32.self, offset: 4) else {
            throw MachOError.ReadError
        }
        
        self.cmdSize = size
        
        guard LoadCommandType.fromRaw(type) == .UnixThread && size >= 8 else {
            throw MachOError.BadFormat
        }
        
        var cur = data[8..<Int(size)]
        while cur.count > 0 {
            guard let flavor = cur.tryGetGeneric(type: UInt32.self) else {
                throw MachOError.ReadError
            }
            
            guard let count = cur.tryGetGeneric(type: UInt32.self, offset: 4) else {
                throw MachOError.ReadError
            }
            
            cur = cur.tryAdvance(by: 8)
            
            guard cur.count >= (Int(count) * 4) else {
                throw MachOError.ReadError
            }
            
            threadStates.append((flavor: flavor, state: cur[0..<(Int(count)*4)]))
            
            cur = cur.tryAdvance(by: Int(count) * 4)
        }
    }
}
