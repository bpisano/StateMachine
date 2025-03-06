//
//  StateTransition.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

@propertyWrapper
public final class StateTransition {
    public var wrappedValue: StateTransitionHandler {
        guard let transitionHandler = transitionHandler else {
            assertionFailure("Accessing @StateTransition within a state that is not managed by a StateMachine.")
            return .init()
        }
        return transitionHandler
    }

    private var transitionHandler: StateTransitionHandler?

    public init() { }

    func inject(transitionHandler: StateTransitionHandler) {
        self.transitionHandler = transitionHandler
    }
}
