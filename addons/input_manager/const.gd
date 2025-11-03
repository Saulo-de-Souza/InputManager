@abstract class_name InputManagerConst extends RefCounted


enum _event_type_enum {
	## When the button is pressed.
	PRESSED,
	## When the button is released.
	RELESED,
	## Only one shot can be fired when pressing or holding the button.
	ONE_SHOT,
	## It alternates every time you press it. Ideal for changing states, such as lowering a character, etc.
	TOGGLE
	}
