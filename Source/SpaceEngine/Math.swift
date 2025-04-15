import Foundation
import SpriteKit

extension Transform {

	init(point: CGPoint, vector: CGVector) {
		x = Float(point.x)
		y = Float(point.y)
		zRotation = Float(vector.angle)
	}

	func move(by vector: CGVector) -> Transform {
		let rotated = vector.rotate(CGFloat(zRotation))
		return Transform(
			x: x + Float(rotated.dx),
			y: y + Float(rotated.dy),
			zRotation: zRotation
		)
	}
}

extension CGVector {

	public func rotate(_ angle: CGFloat) -> CGVector {
		return CGVector(
			dx: dx * cos(angle) - dy * sin(angle),
			dy: dx * sin(angle) + dy * cos(angle)
		)
	}

	public var lengthSquared: CGFloat { dx * dx + dy * dy }
	public var length: CGFloat { sqrt(lengthSquared) }
	public var angle: CGFloat { atan2(dy, dx) }
	public var point: CGPoint { CGPoint(x: dx, y: dy) }

	func normalized() -> CGVector { self / sqrt(lengthSquared) }

	public func dot(_ vector: CGVector) -> CGFloat {
		dx * vector.dx + dy * vector.dy
	}
	public func cross(_ vector: CGVector) -> CGFloat {
		dx * vector.dy - dy * vector.dx
	}

	public func angle(with vector: CGVector) -> CGFloat {
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

public extension CGPoint {

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

	public var orientation: CGVector {
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
