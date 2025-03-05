//
//  EmptyStateMachineContext.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

public struct EmptyStateMachineContext: StateMachineContext {
    public static let defaultValue: EmptyStateMachineContext = .init()
}
