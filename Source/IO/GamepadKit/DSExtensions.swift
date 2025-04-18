enum DSButton: Int {
	case square = 1
	case cross = 2
	case circle = 3
	case triangle = 4
	case l1 = 5
	case r1 = 6
	case l2 = 7
	case r2 = 8
	case share = 9
	case options = 10
}

enum DSStick {
	case left
	case right
}

enum DSTrigger {
	case left
	case right
}

enum DSHatDirection: Int {
	case null		= 0
	case up			= 1
	case right		= 2
	case down		= 4
	case left		= 8
	case upRight	= 3
	case downRight	= 6
	case upLeft		= 9
	case downLeft	= 12
}

enum DSControl {
	case button(DSButton)
	case stick(DSStick)
	case trigger(DSTrigger)
	case dPad(DSHatDirection)
}
