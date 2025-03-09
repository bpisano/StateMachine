//
//  StateMachineStateWrapper.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

struct StateMachineStateWrapper<Context: StateMachineContext>: Sendable {
    let state: StateMachineState
    let transitionHandler: StateTransitionHandler
    let context: Context

    @MainActor
    func makeInjection() {
        let mirror: Mirror = .init(reflecting: state)
        for child in mirror.children {
            if let propertyWrapper = child.value as? StateTransition {
                propertyWrapper.inject(transitionHandler: transitionHandler)
            }
            if let propertyWrapper = child.value as? StateContext<Context> {
                propertyWrapper.inject(context: context)
            }
        }
    }
}
