import PowerCore
import CoreGraphics.CGBase
import Fx

extension Store {

	func getComponentAt(index: Int) -> () -> Component {
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

struct Closure<A> {
	let get: () -> A
	let set: (A) -> ()

	var value: A {
		get {
			return get()
		}
		nonmutating set {
			set(newValue)
		}
	}

	func update(f: (inout A) -> ()) {
		var value = get()
		f(&value)
		set(value)
	}
}

extension Store {

	subscript(sharedIndex: Box<Int>) -> Component {
		get {
			return self[sharedIndex.value]
		}
		set {
			self[sharedIndex.value] = newValue
		}
	}

	func closureAt(index: Int) -> Closure<Component> {
		let sharedIndex = sharedIndexAt(index)

		return Closure(
			get: {
				self[sharedIndex]
			},
			set: { data in
				self[sharedIndex] = data
			}
		)
	}

	func weakClosure(entity: Entity) -> Closure<Component?> {
		return Closure(
			get: {
				{self[$0]} <^> self.indexOf(entity)
			},
			set: { newValue in
				guard let index = self.indexOf(entity), newValue = newValue else { return }
				self[index] = newValue
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

extension Set {

	func filterSet(@noescape predicate: (Element) -> Bool) -> Set<Element> {
		var newValue = Set<Element>(minimumCapacity: count)
		for element in self where predicate(element) {
			newValue.insert(element)
		}

		return newValue
	}
}
