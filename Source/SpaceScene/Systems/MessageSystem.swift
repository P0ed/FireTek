import Fx

final class MessageSystem {
	private let world: World

	private var messages = Quad(repeating: Cursor16<Message>())
	private var replyTo = Array16<(Entity, Action) -> Void>(repeating: { _, _ in }, count: 16)
	private var targets = Set<Entity>()
	private var replying = false
	private(set) var text: String = ""

	private var player: Entity? { world.players.first }
	private var playerMessages: Cursor16<Message> { get { messages[0] } set { messages[0] = newValue } }
	private var message: Message? { playerMessages.current }

	init(world: World) {
		self.world = world
	}

	func clearSystemMessages(_ system: System) {
		messages[0].removeAll { msg in msg.system == system }
		updateText()
	}

	func send(_ message: Message) {
		guard let player else { return }
		send(message, to: player)
	}

	func send(_ message: Message, to entity: Entity) {
		guard let idx = world.players.firstIndex(of: entity) else { return }

		messages[idx].append(message)
		updateText()

		if let target = message.target { targets.insert(target) }
	}

	func monitor(system: System, reply: @escaping (Entity, Action) -> Void) {
		replyTo[system.index] = reply
	}

	private func updateText() {
		guard let player else { return }
		if let message {
			text = playerMessages.head + message.text
			world.ships[player]?.target = message.target
			if let t = message.target {
				print("set target: \(t) \(message.head)")
			} else {
				print("set target: nil \(message.head)")
			}
		} else {
			text = playerMessages.head
			world.ships[player]?.target = nil
		}
	}

	private var selecting = false
	func update(input: inout Input) {
		let em = world.entityManager
		for target in targets {
			if !em.isAlive(target) {
				for (idx, msg) in playerMessages.enumerated().reversed() {
					if msg.target == target {
						playerMessages.remove(at: idx)
						updateText()
					}
				}
				targets.remove(target)
			}
		}

		if let message, !message.action.isEmpty {
			let action = input.action ? .a : input.scan ? .b : [] as Action
			if !action.isEmpty, action.isSubset(of: message.action), let player, !replying {
				replying = true
				replyTo[message.system.index](player, action)
			} else if action.isEmpty, replying {
				replying = false
			}
			input.action = false
			input.scan = false
		}
		if input.dpad.up, !selecting {
			selecting = true
			playerMessages.selectPrev()
			updateText()
		} else if input.dpad.down, !selecting {
			selecting = true
			playerMessages.selectNext()
			updateText()
		} else if selecting, !input.dpad.up, !input.dpad.down {
			selecting = false
		}
	}
}

struct Cursor16<A>: RandomAccessCollection, RangeReplaceableCollection {
	private var array: Array16<A> = .init([])
	private(set) var index: Int = 0

	init() {}

	var startIndex: Int { array.startIndex }
	var endIndex: Int { array.endIndex }
	func index(after i: Int) -> Int { array.index(after: i) }

	subscript(position: Int) -> A {
		get { array[position] }
		set { array[position] = newValue }
	}

	mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C) where C : Collection, Self.Element == C.Element {
		array.replaceSubrange(subrange, with: newElements)
		if subrange.contains(index) {
			index = Swift.max(0, subrange.lowerBound - 1)
		} else if index > subrange.upperBound {
			index += newElements.count - subrange.count
		}
	}

	var current: A? { index < array.count ? array[index] : nil }
	var next: A? { index < array.count - 1 ? array[index + 1] : nil }
	var prev: A? { index > 0 && index - 1 < array.count ? array[index - 1] : nil }

	mutating func selectNext() {
		index = Swift.min(Swift.max(0, array.count - 1), index + 1)
	}
	mutating func selectPrev() {
		index = Swift.max(0, index - 1)
	}
}

extension Cursor16<Message> {
	var head: String {
		array.count < 2 ? (array.isEmpty ? "..." : "")
		: "\(prev?.head ?? "...")\n\(current?.head ?? "...")\n\(next?.head ?? "...")\n\n"
	}
}

struct Message {
	var system: System
	var target: Entity?
	var text: String
	var action: Action

	init(
		system: System = .none,
		target: Entity? = nil,
		text: String,
		act: String? = nil,
		scan: String? = nil
	) {
		self.system = system
		self.target = target
		self.text = text
		+ (act.map { "\nACT: " + $0 } ?? "")
		+ (scan.map { "\nSCAN: " + $0 } ?? "")
		self.action = [act == nil ? [] : .a, scan == nil ? [] : .b]
	}
}

extension Message {
	var head: String {
		.init(text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)[0])
	}
}

struct Action: OptionSet, Hashable {
	var rawValue: UInt8

	static let none = Action(rawValue: 0 << 0)
	static let a = Action(rawValue: 1 << 0)
	static let b = Action(rawValue: 1 << 1)
}

enum System: UInt8 {
	case none, target, planet
	var index: Int { Int(rawValue) }
}
