# StateMachine

A Swift package for creating state machines.

## Installation

Add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/bpisano/StateMachine", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

You can start by defining your state by creating structs that conforms to the `StateMachineState` protocol. To transition between states, use the `@StateTransition` property wrapper.

Here is an example of states that toggles between an on and off:

```swift
import StateMachine

struct OnState: StateMachineState {
    @StateTransition private var transition

    func enter() async {
        print("ON")
        Task {
            try? await Task.sleep(for: .seconds(1))
            transition(to: OffState())
        }
    }
}

struct OffState: StateMachineState {
    @StateTransition private var transition

    func enter() async {
        print("OFF")
        Task {
            try? await Task.sleep(for: .seconds(1))
            transition(to: OnState())
        }
    }
}
```

You can then create and start your state machine by providing the initial state:

```swift
let stateMachine = StateMachine(initialState: OffState())
await stateMachine.start()
```

This should result with the following output:

```bash
OFF
ON
OFF
ON
...
```

### Adding context

You can add context to your state machine by providing a type that conforms to the `StateMachineContext` protocol:

```swift
struct MyContext: StateMachineContext {
    static let defaultValue: MyContext = .init(delay: 1)

    let delay: TimeInterval
}
```

> You need to provide a default value for your context by using the `defaultValue` property.

This context can be accessed from your states by using the `@StateContext` property wrapper:

```swift
struct OnState: StateMachineState {
    @StateTransition private var transition
    @StateContext private var context: MyContext

    func enter() async {
        print("ON")
        Task {
            try? await Task.sleep(for: .seconds(await context.delay))
            transition(to: OffState())
        }
    }
}
```

To create your state machine with a context, use the `ContextualStateMachine` type:

```swift
let stateMachine = ContextualStateMachine(
    initialState: OffState(),
    context: MyContext(delay: 1)
)
await stateMachine.start()
```
