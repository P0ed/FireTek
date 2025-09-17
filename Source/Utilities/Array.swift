struct Quad<A>: RandomAccessCollection {
	var v0: A
	var v1: A
	var v2: A
	var v3: A

	init(_ v0: A, _ v1: A, _ v2: A, _ v3: A) {
		self.v0 = v0
		self.v1 = v1
		self.v2 = v2
		self.v3 = v3
	}

	init(repeating value: A) { self = Quad(value, value, value, value) }

	subscript(position: Int) -> A {
		get {
			switch position % 4 {
			case 0: return v0
			case 1: return v1
			case 2: return v2
			default: return v3
			}
		}
		set {
			switch position % 4 {
			case 0: v0 = newValue
			case 1: v1 = newValue
			case 2: v2 = newValue
			default: v3 = newValue
			}
		}
	}

	var startIndex: Int { 0 }
	var endIndex: Int { 4 }
	func index(after i: Int) -> Int { i + 1 }
}

struct Array4<A>: RandomAccessCollection, RangeReplaceableCollection {
	private var q: Quad<A?>
	private var cnt: Int

	init() {
		q = Quad(repeating: nil)
		cnt = 0
	}
	init<C: Collection>(_ collection: C) where C.Element == A {
		guard collection.count <= 4 else { fatalError() }
		self = Self.init()
		for (i, e) in collection.enumerated() { q[i] = e }
		cnt = collection.count
	}

	subscript(position: Int) -> A {
		get { q[position]! }
		set { q[position] = newValue }
	}

	var startIndex: Int { 0 }
	var endIndex: Int { cnt }
	func index(after i: Int) -> Int { i + 1 }

	private mutating func ins(_ e: A, at i: Int) {
		guard cnt < 4, i <= cnt else { fatalError() }
		if i != cnt {
			for idx in ((i + 1)...(count - 1)).reversed() {
				self[idx] = self[idx - 1]
			}
		}
		self[i] = e
		cnt += 1
	}

	private mutating func rm(at i: Int) {
		guard cnt > 0, i < cnt else { fatalError() }
		for i in i..<count - 1 {
			self[i] = self[i + 1]
		}
		cnt -= 1
	}

	mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C) where C : Collection, Self.Element == C.Element {
		for i in subrange { rm(at: i) }
		for e in newElements { ins(e, at: subrange.lowerBound) }
	}
}

struct Array16<A>: RandomAccessCollection, RangeReplaceableCollection {
	private var q: Quad<Quad<A?>> = .init(repeating: .init(repeating: nil))
	private var cnt: Int

	init() { cnt = 0 }
	init<C: Collection>(_ collection: C) where C.Element == A {
		guard collection.count <= 16 else { fatalError() }
		for (i, e) in collection.enumerated() { q[i / 4][i] = e }
		cnt = collection.count
	}

	subscript(position: Int) -> A {
		get { q[position / 4][position]! }
		set { q[position / 4][position] = newValue }
	}

	var startIndex: Int { 0 }
	var endIndex: Int { cnt }
	func index(after i: Int) -> Int { i + 1 }

	private mutating func insrt(_ newElement: A, at i: Int) {
		guard cnt < 16, i <= cnt else { fatalError() }
		cnt += 1
		for i in ((i + 1)..<cnt).reversed() { self[i] = self[i - 1] }
		self[i] = newElement
	}

	private mutating func rm(at i: Int) {
		guard cnt > 0, i < cnt else { fatalError() }
		for i in i..<cnt - 1 {
			self[i] = self[i + 1]
		}
		cnt -= 1
	}

	mutating func replaceSubrange<C>(_ subrange: Range<Self.Index>, with newElements: C) where C : Collection, Self.Element == C.Element {
		let sublen = subrange.count
		let elslen = newElements.count
		for (i, e) in newElements.enumerated() {
			if i < sublen {
				self[i + subrange.lowerBound] = e
			} else {
				insrt(e, at: i + subrange.lowerBound)
			}
		}
		if sublen > elslen {
			for i in subrange.dropFirst(elslen).reversed() {
				rm(at: i)
			}
		}
	}
}

extension Array4: Equatable where A: Equatable {
	static func == (lhs: Array4<A>, rhs: Array4<A>) -> Bool {
		lhs.count == rhs.count && zip(lhs, rhs).reduce(true, { r, e in r && e.0 == e.1 })
	}
}

extension Array4: ExpressibleByArrayLiteral {
	init(arrayLiteral elements: A...) { self = .init(elements) }
}

extension Array16: ExpressibleByArrayLiteral {
	init(arrayLiteral elements: A...) { self = .init(elements) }
}
