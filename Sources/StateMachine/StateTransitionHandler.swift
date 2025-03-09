//
//  StateMachineTransition.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

@MainActor
public final class StateTransitionHandler {
    typealias Handler = @Sendable (_ newState: StateMachineState) async -> Void

    private var transitionHandler: Handler?

    public func callAsFunction(to newState: StateMachineState) async {
        await transitionHandler?(newState)
    }

    func onTransition(_ handler: @escaping Handler) {
        self.transitionHandler = handler
    }
}
