@tool

class_name InputManagerDefaultTouch extends CanvasLayer


@onready var a: TouchScreenButton = $A
@onready var b: TouchScreenButton = $B
@onready var x: TouchScreenButton = $X
@onready var y: TouchScreenButton = $Y
@onready var lt: TouchScreenButton = $LT
@onready var rt: TouchScreenButton = $RT
@onready var lb: TouchScreenButton = $LB
@onready var rb: TouchScreenButton = $RB
@onready var dpad_up: TouchScreenButton = $DPAD_UP
@onready var dpad_down: TouchScreenButton = $DPAD_DOWN
@onready var dpad_left: TouchScreenButton = $DPAD_LEFT
@onready var dpad_right: TouchScreenButton = $DPAD_RIGHT
@onready var start: TouchScreenButton = $START
@onready var select: TouchScreenButton = $SELECT
@onready var ls: VirtualJoystick = $LS
@onready var rs: VirtualJoystick = $RS
@onready var lsb: TouchScreenButton = $LSB
@onready var rsb: TouchScreenButton = $RSB


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
