//
//  File.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 09/03/2025.
//

import Foundation
import StateMachine

struct OffState: StateMachineState {
    @StateTransition private var transition

    func enter() async {
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await transition(to: OnState())
        }
    }
}
