import SpriteKit

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
	var normalized: CGVector { self / length }

	func dot(_ vector: CGVector) -> CGFloat {
		dx * vector.dx + dy * vector.dy
	}
	func cross(_ vector: CGVector) -> CGFloat {
		dx * vector.dy - dy * vector.dx
	}

	func angle(with vector: CGVector) -> CGFloat {
		let t1 = normalized
		let t2 = vector.normalized
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
		CGSize(width: side, height: side)
	}
}

extension CGFloat {
	var vector: CGVector { .init(dx: 0, dy: 1).rotate(self) }
}
