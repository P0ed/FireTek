import SpriteKit

struct Tile {
	let color: SKColor
}

final class Level {

	let tileMap: TileMap<Tile>

	init() {
		tileMap = Level.generateTileMap()
	}

	static func generateTileMap() -> TileMap<Tile> {

		let generator = HeightMapGenerator(detail: 6)
		generator.diamondSquare(0.7)

		return generator.heightMap.map { value in
			let h = CGFloat(Int(((value + 1) / 2) * 4)) / 4
			let color = SKColor(red: 0.1 + h / 3, green: 0.2 + h / 2, blue: 0.3 + h / 4, alpha: 1)
			return Tile(color: color)
		}
	}
}
