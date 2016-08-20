import PowerCore

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

struct Vector {
	var dx: Float
	var dy: Float
}
