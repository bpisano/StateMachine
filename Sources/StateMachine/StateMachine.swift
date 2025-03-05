//
//  StateMachine.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation

@MainActor
public final class StateMachine<Context: StateMachineContext> {
    public var currentState: StateMachineState {
        get { currentStateWrapper.state }
        set {
            currentStateWrapper = .init(
                state: newValue,
                transitionHandler: transitionHandler,
                context: context
            )
        }
    }

    private let initialState: StateMachineState
    private let context: Context
    private let transitionHandler: StateTransitionHandler = .init()
    private var currentStateWrapper: StateMachineStateWrapper<Context>

    public init(
        initialState: StateMachineState,
        context: Context
    ) {
        self.initialState = initialState
        self.context = context
        self.currentStateWrapper = .init(
            state: initialState,
            transitionHandler: transitionHandler,
            context: context
        )
    }

    public func start() async {
        transitionHandler.onTransition { [weak self] newState in
            guard let self else { return }
            await self.transition(to: newState)
        }
        await initialState.enter()
    }

    private func transition(to newState: StateMachineState) async {
        await currentState.exit()
        currentState = newState
        await currentState.enter()
    }
}

extension StateMachine where Context == EmptyStateMachineContext {
    public convenience init(initialState: StateMachineState) {
        self.init(
            initialState: initialState,
            context: .init()
        )
    }
}
