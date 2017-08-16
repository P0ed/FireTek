import PowerCore
import CoreGraphics.CGBase
import Fx

struct Transform {
	var x: Float
	var y: Float
	var zRotation: Float
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

extension Store {

	func first(_ f: (C) -> Bool) -> Ref<C>? {
		for (idx, c) in enumerated() where f(c) {
			return refAt(idx)
		}
		return nil
	}

	func first(_ entities: Entity...) -> Ref<C>? {
		for e in entities {
			if let idx = indexOf(e) { return refAt(idx) }
		}
		return nil
	}

	func refOf(_ e: Entity) -> Ref<C>? {
		if let idx = indexOf(e) {
			return refAt(idx)
		}
		return nil
	}

	func weakRefOf(_ e: Entity) -> WeakRef<C>? {
		if let idx = indexOf(e) {
			return weakRefAt(idx)
		}
		return nil
	}
}

extension Set {

	func filterSet(_ predicate: (Element) -> Bool) -> Set<Element> {
		var newValue = Set<Element>(minimumCapacity: count)
		for element in self where predicate(element) {
			newValue.insert(element)
		}

		return newValue
	}
}

extension Array {

	mutating func fastRemove(at index: Int) {
		self[index] = self[count - 1]
		self.removeLast()
	}
}
