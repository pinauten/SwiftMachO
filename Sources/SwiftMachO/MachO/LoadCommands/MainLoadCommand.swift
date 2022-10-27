//
//  MainLoadCommand.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2021-12-15.
//  Copyright © 2021 Pinauten GmbH. All rights reserved.
//

import Foundation

open class MainLoadCommand: LoadCommand {
    public var type: LoadCommandType { .Main }
    public var cmdSize: UInt32 { 24 }
    
    public var entryOffset: UInt64
    public var stackSize:   UInt64
    
    public required init(fromData data: Data) throws {
        guard let type = data.tryGetGeneric(type: UInt32.self) else {
            throw MachOError.ReadError
        }
        
        guard let size = data.tryGetGeneric(type: UInt32.self, offset: 4) else {
            throw MachOError.ReadError
        }
        
        guard LoadCommandType.fromRaw(type) == .Main && size == 24 else {
            throw MachOError.BadFormat
        }
        
        guard let entryOffset = data.tryGetGeneric(type: UInt64.self, offset: 8) else {
            throw MachOError.ReadError
        }
        
        guard let stackSize = data.tryGetGeneric(type: UInt64.self, offset: 16) else {
            throw MachOError.ReadError
        }
        
        self.entryOffset = entryOffset
        self.stackSize   = stackSize
    }
}
