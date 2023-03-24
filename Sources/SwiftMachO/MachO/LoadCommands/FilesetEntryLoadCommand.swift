//
//  FilesetEntryLoadCommand.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2023-03-24.
//  Copyright © 2023 Pinauten GmbH. All rights reserved.
//

import Foundation

open class FilesetEntryLoadCommand: LoadCommand {
    public var type: LoadCommandType { .FilesetEntry }
    public var cmdSize: UInt32
    
    public var vmAddress: UInt64
    public var fileOffset: UInt64
    public var name: String
    
    public required init(fromData data: Data) throws {
        guard let type = data.tryGetGeneric(type: UInt32.self) else {
            throw MachOError.ReadError
        }
        
        guard let size = data.tryGetGeneric(type: UInt32.self, offset: 4) else {
            throw MachOError.ReadError
        }
        
        self.cmdSize = size
        
        guard LoadCommandType.fromRaw(type) == .FilesetEntry && size >= 32 else {
            throw MachOError.BadFormat
        }
        
        guard let vmAddress = data.tryGetGeneric(type: UInt64.self, offset: 8) else {
            throw MachOError.ReadError
        }
        
        self.vmAddress = vmAddress
        
        guard let fileOffset = data.tryGetGeneric(type: UInt64.self, offset: 16) else {
            throw MachOError.ReadError
        }
        
        self.fileOffset = fileOffset
        
        guard let stringOffset = data.tryGetGeneric(type: UInt32.self, offset: 24) else {
            throw MachOError.ReadError
        }
        
        guard stringOffset < size else {
            throw MachOError.BadFormat
        }
        
        let strData = data.subdata(in: Int(stringOffset)..<Int(size))
        self.name   = try strData.toString(encoding: .utf8, nullTerminated: true)
    }
}
