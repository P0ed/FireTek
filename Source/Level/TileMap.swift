struct TileMap<Tile> {
	let size: Int
	private var array: [Tile]

	private init(size: Int, array: [Tile]) {
		self.size = size
		self.array = array
	}

	init(size: Int, value: Tile) {
		self.size = size
		array = Array<Tile>(count: size * size, repeatedValue: value)
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

	func forEach(@noescape f: (position: (x: Int, y: Int), tile: Tile) -> ()) {
		return array.enumerate().forEach { index, tile in
			f(position: (x: index % size, y: index / size), tile: tile)
		}
	}

	func map<T>(@noescape f: Tile -> T) -> TileMap<T> {
		return TileMap<T>(size: size, array: array.map(f))
	}
}
