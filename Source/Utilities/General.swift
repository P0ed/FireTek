import PowerCore
import CoreGraphics.CGBase
import Fx
import Runes

extension Store {

	func getComponentAt(_ index: Int) -> () -> C {
		let sharedIndex = sharedIndexAt(index)
		return {
			self[sharedIndex.value]
		}
	}
}

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

//struct Closure<A> {
//	let get: () -> A
//	let set: (A) -> ()
//
//	var value: A {
//		get {
//			return get()
//		}
//		nonmutating set {
//			set(newValue)
//		}
//	}
//
//	func update(_ f: (inout A) -> ()) {
//		var value = get()
//		f(&value)
//		set(value)
//	}
//}

extension Store {

	subscript(sharedIndex: Box<Int>) -> C {
		get {
			return self[sharedIndex.value]
		}
		set {
			self[sharedIndex.value] = newValue
		}
	}

	func find(_ f: (C) -> Bool) -> Int? {
		for (index, component) in self.enumerated() {
			if f(component) {
				return .some(index)
			}
		}
		return .none
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
