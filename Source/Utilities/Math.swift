import Foundation
import SpriteKit

extension CGVector {

	public func rotate(angle: CGFloat) -> CGVector {
		return CGVector(
			dx: dx * cos(angle) - dy * sin(angle),
			dy: dx * sin(angle) + dy * cos(angle)
		)
	}

	public var lengthSquared: CGFloat {
		return dx * dx + dy * dy
	}

	public var length: CGFloat {
		return sqrt(lengthSquared)
	}

	public var angle: CGFloat {
		return atan2(dy, dx)
	}

	public var asPoint: CGPoint {
		return CGPoint(x: dx, y: dy)
	}

	func normalized() -> CGVector {
		return self / sqrt(lengthSquared)
	}

	public func dot(vector: CGVector) -> CGFloat {
		return dx * vector.dx + dy * vector.dy
	}

	public func cross(vector: CGVector) -> CGFloat {
		return dx * vector.dy - dy * vector.dx
	}

	public func angle(with vector: CGVector) -> CGFloat {
		let t1 = normalized()
		let t2 = vector.normalized()
		let cross = t1.cross(t2)
		let dot = max(-1, min(1, t1.dot(t2)))

		return atan2(cross, dot)
	}
}

public func * (vector: CGVector, scale: CGFloat) -> CGVector {
	return CGVector(dx: vector.dx * scale, dy: vector.dy * scale)
}

public func / (vector: CGVector, scale: CGFloat) -> CGVector {
	return CGVector(dx: vector.dx / scale, dy: vector.dy / scale)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector {
	return CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
}

public func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
	return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

extension CGPoint {

	public func distance(to point: CGPoint) -> CGFloat {
		let dx = abs(x - point.x)
		let dy = abs(y - point.y)
		return sqrt(dx * dx + dy * dy)
	}

	public var asVector: CGVector {
		return CGVector(dx: x, dy: y)
	}
}

extension SKNode {

	public var orientation: CGVector {
		return CGVector(dx: 0, dy: 1).rotate(zRotation)
	}
}