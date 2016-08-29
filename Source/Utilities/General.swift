import PowerCore
import CoreGraphics.CGBase

extension Store {

	func getComponentAt(index: Int) -> () -> Component {
		let sharedIndex = sharedIndexAt(index)
		return {
			self[sharedIndex.value]
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

public struct Closure<A> {
	public typealias Getter = () -> (A)
	public typealias Setter = (A) -> ()

	let get: Getter
	let set: Setter

	public init(get: Getter, set: Setter) {
		self.get = get
		self.set = set
	}

	var value: A {
		get {
			return get()
		}
		nonmutating set {
			set(newValue)
		}
	}
}

extension Store {

	func closureAt(index: Int) -> Closure<Component> {
		let sharedIndex = sharedIndexAt(index)
		return Closure(
			get: {
				self[sharedIndex.value]
			},
			set: { data in
				self[sharedIndex.value] = data
			}
		)
	}

	func find(f: Component -> Bool) -> Int? {
		for (index, component) in self.enumerate() {
			if f(component) {
				return .Some(index)
			}
		}
		return .None
	}
}
