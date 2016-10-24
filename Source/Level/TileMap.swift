struct TileMap<Tile> {
	let size: Int
	fileprivate var array: [Tile]

	fileprivate init(size: Int, array: [Tile]) {
		self.size = size
		self.array = array
	}

	init(size: Int, value: Tile) {
		self.size = size
		array = Array<Tile>(repeating: value, count: size * size)
	}

	subscript(x: Int, y: Int) -> Tile {
		get {
			return array[y * size + x]
		}
		set {
			array[y * size + x] = newValue
		}
	}
}

extension TileMap {

	func forEach(_ f: (_ position: (x: Int, y: Int), _ tile: Tile) -> ()) {
		return array.enumerated().forEach { index, tile in
			f((x: index % size, y: index / size), tile)
		}
	}

	func map<T>(_ f: (Tile) -> T) -> TileMap<T> {
		return TileMap<T>(size: size, array: array.map(f))
	}
}
