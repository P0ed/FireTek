import PowerCore
import CoreGraphics.CGBase

extension Store {

	func getComponentAt(idx: Int) -> () -> Component {
		let sharedIdx = sharedIndexAt(idx)
		return {
			self[sharedIdx.value]
		}
	}
}

struct Point {
	var x: Float
	var y: Float
}

extension Point {
	var cgPoint: CGPoint {
		return CGPoint(x: Double(x), y: Double(y))
	}
}

struct Vector {
	var dx: Float
	var dy: Float
}
