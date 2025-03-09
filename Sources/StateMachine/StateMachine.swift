//
//  StateMachine.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation
@preconcurrency import Combine

public typealias StateMachine = ContextualStateMachine<EmptyStateMachineContext>

@MainActor
public final class ContextualStateMachine<Context: StateMachineContext> {
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
    public var currentStatePublisher: AnyPublisher<StateMachineState, Never> {
        Just(currentState)
            .merge(with: currentStateWrapperPublisher.map(\.state))
            .eraseToAnyPublisher()
    }

    private let initialState: StateMachineState
    private let context: Context
    private let transitionHandler: StateTransitionHandler = .init()
    private var currentStateWrapper: StateMachineStateWrapper<Context> {
        didSet {
            currentStateWrapperPublisher.send(currentStateWrapper)
        }
    }
    private let currentStateWrapperPublisher: PassthroughSubject<StateMachineStateWrapper<Context>, Never> = .init()

    public nonisolated init(
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
        currentStateWrapper.makeInjection()
        await initialState.enter()
    }

    public func transition(to newState: StateMachineState) async {
        await currentState.exit()
        currentState = newState
        currentStateWrapper.makeInjection()
        await currentState.enter()
    }
}

public extension ContextualStateMachine where Context == EmptyStateMachineContext {
    convenience nonisolated init(initialState: StateMachineState) {
        self.init(
            initialState: initialState,
            context: .init()
        )
    }
}
