//
//  StateMachine.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//

import Foundation
@preconcurrency import Combine

public typealias StateMachine = ContextualStateMachine<EmptyStateMachineContext>

public final actor ContextualStateMachine<Context: StateMachineContext> {
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
        currentStateWrapperPublisher
            .map(\.state)
            .eraseToAnyPublisher()
    }

    private let initialState: StateMachineState
    private let context: Context
    private let transitionHandler: StateTransitionHandler = .init()
    private var currentStateWrapper: StateMachineStateWrapper<Context> {
        get { currentStateWrapperPublisher.value }
        set { currentStateWrapperPublisher.send(newValue) }
    }
    private let currentStateWrapperPublisher: CurrentValueSubject<StateMachineStateWrapper<Context>, Never>

    public init(
        initialState: StateMachineState,
        context: Context
    ) {
        self.initialState = initialState
        self.context = context
        self.currentStateWrapperPublisher = .init(
            .init(
                state: initialState,
                transitionHandler: transitionHandler,
                context: context
            )
        )
    }

    func start() async {
        await transitionHandler.onTransition { [weak self] newState in
            guard let self else { return }
            await self.transition(to: newState)
        }
        currentStateWrapper.makeInjection()
        await initialState.enter()
    }

    func transition(to newState: StateMachineState) async {
        await currentState.exit()
        currentState = newState
        currentStateWrapper.makeInjection()
        await currentState.enter()
    }
}

extension ContextualStateMachine where Context == EmptyStateMachineContext {
    init(initialState: StateMachineState) {
        self.init(
            initialState: initialState,
            context: .init()
        )
    }
}
