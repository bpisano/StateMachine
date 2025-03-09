//
//  File.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 09/03/2025.
//

import Foundation
import StateMachine

struct Context: StateMachineContext {
    static let defaultValue: Context = .init(
        shouldStopInstantaneously: true
    )

    let shouldStopInstantaneously: Bool
}
