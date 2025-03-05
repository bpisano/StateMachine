//
//  StateContext.swift
//  StateMachine
//
//  Created by Benjamin Pisano on 05/03/2025.
//


@MainActor
@propertyWrapper
public final class StateContext<Context: StateMachineContext> {
    public var wrappedValue: Context {
        guard let context = context else {
            assertionFailure("Accessing @StateContext within a state that is not managed by a StateMachine.")
            return Context.defaultValue
        }
        return context
    }

    private var context: Context?

    public init() { }

    func inject(context: Context) {
        self.context = context
    }
}
