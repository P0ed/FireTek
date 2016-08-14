import GameplayKit

final class HeightMapGenerator {

	private var frand: () -> Float

	var heightMap: TileMap<Float>

	/// The height / width is 2^detail + 1.
	/// Eg detail=8 -> size=257 -> ~1/4 megabyte
	/// https://en.wikipedia.org/wiki/Diamond-square_algorithm
	init(detail: Int, seed: Int? = nil) {
		/// Will be the number of array elements in each dimension (odd number).
		let size = 1 << detail + 1
		heightMap = TileMap<Float>(size: size, value: 0)

		/// Seems like optional functions is broken
		if let seed = seed {
			frand = HeightMapGenerator.randomWithSeed(seed)
		} else {
			frand = HeightMapGenerator.randomWithSource(GKRandomSource())
		}

		let maxIndex = size.predecessor()

		/// Initial corner values.
		heightMap[0, 0] = frand()
		heightMap[maxIndex, 0] = frand()
		heightMap[0, maxIndex] = frand()
		heightMap[maxIndex, maxIndex] = frand()
	}

	private static func randomWithSeed(seed: Int) -> () -> Float {
		var seedValue = seed
		let seedData = NSData(bytes: &seedValue, length: sizeof(seedValue.dynamicType))
		let randomSource = GKARC4RandomSource(seed: seedData)
		return randomWithSource(randomSource)
	}

	private static func randomWithSource(randomSource: GKRandomSource) -> () -> Float {
		return {
			/// Returns in the range -1..1
			randomSource.nextUniform() * 2 - 1
		}
	}

	/// Roughness 1 = rough, 0 = flat. 0.6 looks good.
	func diamondSquare(roughness: Float, seed: Int? = nil) {
		frand = seed.map(HeightMapGenerator.randomWithSeed) ?? frand

		let maxIndex = heightMap.size.predecessor()

		func iterate(subSize: Int, @noescape f: (Int, Int) -> ()) {
			var y = 0
			while y < maxIndex {
				var x = 0
				while x < maxIndex {
					f(x, y)
					x += subSize
				}
				y += subSize
			}
		}

		/// Fill it in.
		var subSize = maxIndex
		var randomScale: Float = 1
		while subSize > 1 {
			iterate(subSize) { x, y in
				diamond(x: x, y: y, size: subSize, randomScale: randomScale)
			}
			iterate(subSize) { x, y in
				square(x: x, y: y, size: subSize, randomScale: randomScale)
			}
			subSize /= 2
			randomScale *= roughness
		}
	}

	/// Sets the midpoint of the square to be the average of the four corner points plus a random value.
	/// x,y are the top left values.
	private func diamond(x x: Int, y: Int, size: Int, randomScale: Float) {
		let tl = heightMap[x, y]
		let tr = heightMap[x + size, y]
		let bl = heightMap[x, y + size]
		let br = heightMap[x + size, y + size]
		let avg = (tl + tr + bl + br) / 4
		heightMap[x + size / 2, y + size / 2] = avg + frand() * randomScale
	}

	/// Sets the midpoints of the sides of the square to be the average of the 3 or
	/// 4 horiz/vert points plus a random value.
	private func square(x x: Int, y: Int, size: Int, randomScale: Float) {
		/// Get all the inputs.
		let half = size / 2
		let tl = heightMap[x, y]
		let tr = heightMap[x + size, y]
		let bl = heightMap[x, y + size]
		let br = heightMap[x + size, y + size]
		let m  = heightMap[x + half, y + half]

		let mapSize = heightMap.size
		let fix: (Int, Int) -> Float? = { x, y in
			(x >= 0 && y >= 0 && x < mapSize && y < mapSize) ? .Some(self.heightMap[x, y]) : .None
		}

		let above = fix(x + half, y - half)
		let below = fix(x + half, y + size + half)
		let left  = fix(x - half, y + half)
		let right = fix(x + size + half, y + half)

//		let average: (Float, Float, Float, Float) -> Float = { ($0 + $1 + $2 + $3) / 4 }

		/// Set the sides.
		heightMap[x + half, y] = average(tl, tr, m, above) + frand() * randomScale	/// Top
		heightMap[x + half, y + size] = average(bl, br, m, below) + frand() * randomScale /// Bottom
		heightMap[x, y + half] = average(tl, bl, m, left)  + frand() * randomScale /// Left
		heightMap[x + size, y + half] = average(tr, br, m, right) + frand() * randomScale /// Right
	}

	private func average(a: Float, _ b: Float, _ c: Float, _ d: Float?) -> Float {
		if let d = d {
			return (a+b+c+d) / 4
		} else {
			return (a+b+c) / 3
		}
	}
}
