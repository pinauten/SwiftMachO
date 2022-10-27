//
//  LoadCommand.swift
//  SwiftMachO
//
//  Created by Linus Henze on 2020-04-08.
//  Copyright © 2020/2021 Pinauten GmbH. All rights reserved.
//

import Foundation

public protocol LoadCommand {
    var type: LoadCommandType { get }
    var cmdSize: UInt32 { get } // Includes 8-Byte header
}
