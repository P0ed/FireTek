

extension HP {
//
//	subscript(x: Int, y: Int) -> UInt8 {
//		get {
//			structure[HP.convert(x: x, y: y)]
//		}
//		set {
//			structure[HP.convert(x: x, y: y)] = newValue
//		}
//	}
//
//	static func convert(x: Int, y: Int) -> Int {
//		switch y {
//		case 0...1:
//			return x + y * 7
//		case 2...4:
//			switch x {
//			case 0...1, 5...6:
//				let yOffset = x > 1 ? 1 : 0
//				let offset = (y - 2 + yOffset) * 3
//				return x + y * 7 - offset
//			default:
//				fatalError("Invalid x: \(x) y: \(y)")
//			}
//		case 5...6:
//			return x + y * 7 - 9
//		default:
//			fatalError("Invalid x: \(x) y: \(y)")
//		}
//	}

	static func convert(i: Int) -> (x: Int, y: Int) {
		let offset = ((i > 15) ? 3 : 0) + ((i > 19) ? 3 : 0) + ((i > 23) ? 3 : 0)
		let i = i + offset
		return (i % 7, i / 7)
	}
}
