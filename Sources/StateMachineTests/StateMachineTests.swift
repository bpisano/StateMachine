//
//  File.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 09/03/2025.
//

import Foundation
import Testing
import StateMachine

@MainActor
final class StateMachineTests {
    @Test
    func stateTransition() async throws {
        let stateMachine: StateMachine = .init(initialState: OnState())
        await stateMachine.start()
        for await state in stateMachine.currentStatePublisher.values {
            if state is OffState {
                break
            }
        }
    }

    @Test()
    func stateContextInstantStop() async throws {
        let stateMachine: ContextualStateMachine<Context> = .init(
            initialState: OnContextuatlState(),
            context: .init(shouldStopInstantaneously: true)
        )
        await stateMachine.start()
        for await state in stateMachine.currentStatePublisher.values {
            if state is StoppedState {
                break
            }
            if state is OffState {
                Issue.record("The state machine should not have continued to transition.")
                #expect(Bool(false))
            }
        }
    }

    @Test()
    func stateContextDelayedStop() async throws {
        let stateMachine: ContextualStateMachine<Context> = .init(
            initialState: OnContextuatlState(),
            context: .init(shouldStopInstantaneously: false)
        )
        await stateMachine.start()
        for await state in stateMachine.currentStatePublisher.values {
            if state is OffState {
                break
            }
            if state is StoppedState {
                Issue.record("The state machine should not have stopped.")
                #expect(Bool(false))
            }
        }
    }
}
