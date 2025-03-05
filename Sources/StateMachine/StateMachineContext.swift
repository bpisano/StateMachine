//
//  File.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

public protocol StateMachineContext: Sendable {
    static var defaultValue: Self { get }
}
