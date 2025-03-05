//
//  StateMachineState.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

@MainActor
public protocol StateMachineState: Sendable {
    func enter() async
    func exit() async
}

public extension StateMachineState {
    func enter() async { }
    func exit() async { }
}
