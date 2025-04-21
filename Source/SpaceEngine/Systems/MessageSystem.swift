import Fx

final class MessageSystem {
	private let messages: Store<Message>
	private var stack: [(Entity, Message)] = []
	private var msgIdx: Int = 0
	private var player: Entity?
	private let replies = SignalPipe<Message>()
	private let disposable = CompositeDisposable()

	var message: Message {
		msgIdx < stack.count ? stack[msgIdx].1 : Message(text: "...")
	}

	var isModal: Bool { !message.action.isEmpty }

	init(world: World) {
		messages = world.messages
	}

	func setup(player: Entity) {
		disposable.dispose()
		self.player = player
		var id = 0
		disposable += messages.newComponents.observe { [weak self] idx in
			guard let self else { return }
			var msg = messages[idx]
			msg.id = id
			id &+= 1
			messages[idx] = msg

			if msg.to == player {
				self.stack.append((messages.entityAt(idx), msg))
			}
		}
		disposable += messages.removedComponents.observe { [weak self] e, c in
			guard let self else { return }
			stack.removeAll(where: { m in m.0 == e })
		}
	}

	func monitorReplies(_ reader: @escaping (Message) -> Void) -> Disposable {
		replies.signal.observe(reader)
	}

	func update(input: inout Input) {
		let msg = message
		if isModal {
			var action = Action.none
			if input.action {
				action = .a
			} else if input.target {
				action = .b
			} else if input.warp {
				action = .c
			}
			if !action.isEmpty {
				replies.put(Message(from: msg.to, to: msg.from, text: "", action: .a))
			}
			input = .empty
		} else {
			if input.dpad.up {
				msgIdx = min(stack.count, msgIdx + 1)
			} else if input.dpad.down {
				msgIdx = max(0, msgIdx - 1)
			}
		}
	}
}
