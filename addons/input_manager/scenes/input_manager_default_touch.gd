@tool

class_name InputManagerDefaultTouch extends CanvasLayer


@onready var rt: TouchScreenButton = $Main/RightBottom/RT
@onready var rb: TouchScreenButton = $Main/RightBottom/RB
@onready var rsb: TouchScreenButton = $Main/RightBottom/RSB
@onready var rs: VirtualJoystick = $Main/RightBottom/RS
@onready var a: TouchScreenButton = $Main/RightBottom/A
@onready var b: TouchScreenButton = $Main/RightBottom/B
@onready var x: TouchScreenButton = $Main/RightBottom/X
@onready var y: TouchScreenButton = $Main/RightBottom/Y
@onready var select: TouchScreenButton = $Main/RightBottom/SELECT
@onready var lt: TouchScreenButton = $Main/LeftBottom/LT
@onready var lb: TouchScreenButton = $Main/LeftBottom/LB
@onready var lsb: TouchScreenButton = $Main/LeftBottom/LSB
@onready var ls: VirtualJoystick = $Main/LeftBottom/LS
@onready var dpad_up: TouchScreenButton = $Main/LeftBottom/DPAD_UP
@onready var dpad_down: TouchScreenButton = $Main/LeftBottom/DPAD_DOWN
@onready var dpad_left: TouchScreenButton = $Main/LeftBottom/DPAD_LEFT
@onready var dpad_right: TouchScreenButton = $Main/LeftBottom/DPAD_RIGHT
@onready var start: TouchScreenButton = $Main/LeftBottom/START




func set_touch_opacity(value: float) -> void:
	if is_node_ready():
		b.modulate.a = value
		a.modulate.a = value
		x.modulate.a = value
		y.modulate.a = value
		lt.modulate.a = value
		rt.modulate.a = value
		lb.modulate.a = value
		rb.modulate.a = value
		dpad_up.modulate.a = value
		dpad_down.modulate.a = value
		dpad_left.modulate.a = value
		dpad_right.modulate.a = value
		start.modulate.a = value
		select.modulate.a = value
		ls.stick_opacity = value
		ls.joystick_opacity = value
		rs.stick_opacity = value
		rs.joystick_opacity = value
		lsb.modulate.a = value
		rsb.modulate.a = value
