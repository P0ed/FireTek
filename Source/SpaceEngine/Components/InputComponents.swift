struct Input {
	var dpad: DPad = .null

	var primary: Bool = false
	var secondary: Bool = false
	var impulse: Bool = false
	var warp: Bool = false
	var action: Bool = false
	var target: Bool = false

	static let empty = Input()
}

typealias DPad = DSHatDirection
extension DPad {

	var up: Bool {
		get { rawValue & Self.up.rawValue != 0 }
		set {
			if newValue {
				self = .init(rawValue: rawValue & 0b1011 | 0b0001)!
			} else {
				self = .init(rawValue: rawValue & 0b1110)!
			}
		}
	}
	var right: Bool {
		get { rawValue & Self.right.rawValue != 0 }
		set {
			if newValue {
				self = .init(rawValue: rawValue & 0b0111 | 0b0010)!
			} else {
				self = .init(rawValue: rawValue & 0b1101)!
			}
		}
	}
	var down: Bool {
		get { rawValue & Self.down.rawValue != 0 }
		set {
			if newValue {
				self = .init(rawValue: rawValue & 0b1110 | 0b0100)!
			} else {
				self = .init(rawValue: rawValue & 0b1011)!
			}
		}
	}
	var left: Bool {
		get { rawValue & Self.left.rawValue != 0 }
		set {
			if newValue {
				self = .init(rawValue: rawValue & 0b1101 | 0b1000)!
			} else {
				self = .init(rawValue: rawValue & 0b0111)!
			}
		}
	}
}

struct Message: Hashable {
	var id: Int = 0
	var from: Entity?
	var to: Entity?
	var target: Entity?
	var text: String = ""
	var action: Action = .none
}

struct Action: OptionSet, Hashable {
	var rawValue: UInt8

	static let none = Action(rawValue: 0 << 0)
	static let a = Action(rawValue: 1 << 0)
	static let b = Action(rawValue: 1 << 1)
	static let c = Action(rawValue: 1 << 2)
}
