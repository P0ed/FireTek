import Fx

final class MessageSystem {
	private let world: World
	private let player: Entity
	private let disposable = CompositeDisposable()
	private var messages: [Entity: Messages] = [:]
	private var targets: Set<Entity> = []

	private var playerMessages: Messages {
		get { messages[player] ?? .init() } set { messages[player] = newValue }
	}
	private var message: Message? { playerMessages.current }
	private var target: Entity? { message?.target }
	private var isModal: Bool { message.map { !$0.action.isEmpty } ?? false }
	var text: String = "..."

	init(world: World, player: Entity) {
		self.world = world
		self.player = player
	}

	func clearSystemMessages(_ system: System) {
		var msgs = messages[player] ?? .init()
		msgs.messages.removeAll { msg in msg.system == system }
		messages[player] = msgs
	}

	func send(_ message: Message) {
		send(message, to: player)
	}

	func send(_ message: Message, to entity: Entity) {
		var msgs = messages[entity] ?? .init()
		msgs.messages.append(message)
		messages[entity] = msgs

		if let target = message.target { targets.insert(target) }
		if entity == player { updateText() }
	}

	private func updateText() {
		if let message {
			text = "\(playerMessages.head)\n\n\(message.text)"
			world.targets[player]?.target = message.target
		} else {
			text = "..."
			world.targets[player]?.target = nil
		}
	}

	private var selecting = false
	func update(input: inout Input) {
		let em = world.entityManager
		for target in targets {
			if !em.isAlive(target) {
				for (idx, msg) in playerMessages.messages.enumerated().reversed() {
					if msg.target == target {
						playerMessages.rm(at: idx)
						updateText()
					}
				}
				targets.remove(target)
			}
		}

		if isModal, let message, let reply = message.reply {
			var action = Action.none
			if input.action {
				action = .a
			} else if input.scan {
				action = .b
			} else if input.warp {
				action = .c
			}
			if !action.isEmpty, action.isSubset(of: message.action) {
				reply(action)
				messages[player]?.rm()
				updateText()
			}
			input = .empty
		} else {
			if input.dpad.up, !selecting {
				selecting = true
				messages[player]?.selectPrev()
				updateText()
			} else if input.dpad.down, !selecting {
				selecting = true
				messages[player]?.selectNext()
				updateText()
			} else if selecting, !input.dpad.up, !input.dpad.down {
				selecting = false
			}
		}
	}
}

struct Messages {
	fileprivate var messages: [Message] = []
	private var index: Int = 0

	var current: Message? { index < messages.count ? messages[index] : nil }
	var next: Message? { index < messages.count - 1 ? messages[index + 1] : nil }
	var prev: Message? { index > 0 ? messages[index - 1] : nil }

	mutating func rm(at idx: Int? = nil) {
		if index < messages.count {
			messages.remove(at: idx ?? index)
			if idx ?? index <= index { selectNext() }
		}
	}
	mutating func selectNext() {
		index = min(max(0, messages.count - 1), index + 1)
	}
	mutating func selectPrev() {
		index = max(0, index - 1)
	}

	var head: String {
		"\(prev?.head ?? "...")\n\(current?.head ?? "...")\n\(next?.head ?? "...")"
	}
}

struct Message {
	var system: System
	var target: Entity?
	var text: String
	var action: Action
	var reply: Optional<(Action) -> Void>

	init(
		system: System = .none,
		target: Entity? = nil,
		text: String = "",
		action: Action = .none,
		reply: Optional<(Action) -> Void> = .none
	) {
		self.system = system
		self.target = target
		self.text = text
		self.action = action
		self.reply = reply
	}
}

extension Message {
	var head: String {
		String(text.split(separator: "\n", maxSplits: 1)[0])
	}
}

struct Action: OptionSet, Hashable {
	var rawValue: UInt8

	static let none = Action(rawValue: 0 << 0)
	static let a = Action(rawValue: 1 << 0)
	static let b = Action(rawValue: 1 << 1)
	static let c = Action(rawValue: 1 << 2)
}

enum System: UInt8 {
	case none, target
}
