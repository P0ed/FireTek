import SpriteKit

extension Transform {

	init(point: CGPoint, vector: CGVector) {
		x = point.x
		y = point.y
		zRotation = vector.angle
	}

	func move(by vector: CGVector) -> Transform {
		let rotated = vector.rotate(CGFloat(zRotation))
		return Transform(
			x: x + rotated.dx,
			y: y + rotated.dy,
			zRotation: zRotation
		)
	}
}

extension CGVector {

	func rotate(_ angle: CGFloat) -> CGVector {
		return CGVector(
			dx: dx * cos(angle) - dy * sin(angle),
			dy: dx * sin(angle) + dy * cos(angle)
		)
	}

	var lengthSquared: CGFloat { dx * dx + dy * dy }
	var length: CGFloat { sqrt(lengthSquared) }
	var angle: CGFloat { atan2(dy, dx) }
	var point: CGPoint { CGPoint(x: dx, y: dy) }

	func normalized() -> CGVector { self / sqrt(lengthSquared) }

	func dot(_ vector: CGVector) -> CGFloat {
		dx * vector.dx + dy * vector.dy
	}
	func cross(_ vector: CGVector) -> CGFloat {
		dx * vector.dy - dy * vector.dx
	}

	func angle(with vector: CGVector) -> CGFloat {
		let t1 = normalized()
		let t2 = vector.normalized()
		let cross = t1.cross(t2)
		let dot = max(-1, min(1, t1.dot(t2)))

		return atan2(cross, dot)
	}

	static func += (lhs: inout CGVector, rhs: CGVector) {
		lhs.dx += rhs.dx
		lhs.dy += rhs.dy
	}
}

func * (vector: CGVector, scale: CGFloat) -> CGVector {
	return CGVector(dx: vector.dx * scale, dy: vector.dy * scale)
}

func / (vector: CGVector, scale: CGFloat) -> CGVector {
	return CGVector(dx: vector.dx / scale, dy: vector.dy / scale)
}

func + (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

func - (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension CGPoint {

	func distance(to point: CGPoint) -> CGFloat {
		let dx = abs(x - point.x)
		let dy = abs(y - point.y)
		return sqrt(dx * dx + dy * dy)
	}

	var vector: CGVector { CGVector(dx: x, dy: y) }

	static func += (lhs: inout CGPoint, rhs: CGVector) {
		lhs.x += rhs.dx
		lhs.y += rhs.dy
	}
}

extension CGSize {

	static func square(side: CGFloat) -> CGSize {
		return CGSize(width: side, height: side)
	}
}

extension SKNode {

	var orientation: CGVector {
		return CGVector(dx: 0, dy: 1).rotate(zRotation)
	}
}

struct Angle {
	var value: UInt16
}

extension Angle {
	static var zero: Angle = .init(value: 0)
	var vector: CGVector { .init(dx: 0, dy: 1).rotate(radians) }
	var radians: CGFloat { CGFloat(spriteIdx) / 16 * .pi }
	var spriteIdx: UInt { UInt(value >> 11) }
}
