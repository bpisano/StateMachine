//
//  File.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 09/03/2025.
//

import Foundation
import StateMachine

@MainActor
struct OnContextualState: StateMachineState {
    @StateTransition private var transition
    @StateContext(Context.self) private var context

    func enter() async {
        if context.shouldStopInstantaneously {
            await transition(to: StoppedState())
        } else {
            await transition(to: OffState())
        }
    }
}
