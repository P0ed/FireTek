struct HPComponent {
	var maxHP: UInt16
	var currentHP: UInt16
	var armor: UInt16
	var structure: [UInt8]

	init(maxHP: UInt16, armor: UInt16 = 0) {
		self.maxHP = maxHP
		self.armor = armor
		currentHP = maxHP
		structure = Array(repeating: .max, count: 40)
	}
}

extension HPComponent {

	subscript(x: Int, y: Int) -> UInt8 {
		get {
			return structure[HPComponent.convert(x: x, y: y)]
		}
		set {
			structure[HPComponent.convert(x: x, y: y)] = newValue
		}
	}

	static func convert(x: Int, y: Int) -> Int {
		switch y {
		case 0...1:
			return x + y * 7
		case 2...4:
			switch x {
			case 0...1, 5...6:
				let yOffset = x > 1 ? 1 : 0
				let offset = (y - 2 + yOffset) * 3
				return x + y * 7 - offset
			default:
				fatalError("Invalid x: \(x) y: \(y)")
			}
		case 5...6:
			return x + y * 7 - 9
		default:
			fatalError("Invalid x: \(x) y: \(y)")
		}
	}

	static func convert(i: Int) -> (x: Int, y: Int) {
		let offset = ((i > 15) ? 3 : 0) + ((i > 19) ? 3 : 0) + ((i > 23) ? 3 : 0)
		let i = i + offset
		return (i % 7, i / 7)
	}
}
