@tool
@icon("res://addons/input_manager/icon.svg")


class_name InputManagerData extends Resource


var owner: InputManager

const POSITION_BUTTON_ABXY_OFFSET: Vector2 = Vector2(-500, -200)
const POSITION_BUTTON_DPADS_OFFSET: Vector2 = Vector2(500, -200)
const POSITION_BUTTON_TRIGGERS_SHOULDERS_OFFSET: Vector2 = Vector2(0, 0)
const POSITION_BUTTON_START_SELECT_OFFSET: Vector2 = Vector2(0, 0)

var _DEFAULT_JOYSTICK_TEXTURE = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_1.png")
var _JOYSTICK_TEXTURE_2 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_2.png")
var _JOYSTICK_TEXTURE_3 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_3.png")
var _JOYSTICK_TEXTURE_4 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_4.png")
var _JOYSTICK_TEXTURE_5 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_5.png")
var _JOYSTICK_TEXTURE_6 = preload("res://addons/input_manager/virtual_joystick/textures/joystick_texture_6.png")

var _DEFAULT_STICK_TEXTURE = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_1.png")
var _STICK_TEXTURE_2 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_2.png")
var _STICK_TEXTURE_3 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_3.png")
var _STICK_TEXTURE_4 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_4.png")
var _STICK_TEXTURE_5 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_5.png")
var _STICK_TEXTURE_6 = preload("res://addons/input_manager/virtual_joystick/textures/stick_texture_6.png")

@export_group("Joystick")
## Device id.
@export_range(0, 10, 1, "or_greater") var _device: int = 0
## Left Stick deadzone.
@export_range(0.0, 1.0, 0.01) var _left_stick_deadzone: float = 0.2
## Right Stick deadzone.
@export_range(0.0, 1.0, 0.01) var _right_stick_deadzone: float = 0.2
## Left Trigger deadzone.
@export_range(0.0, 1.0, 0.01) var _left_trigger_deadzone: float = 0.0
## Right Trigger deadzone.
@export_range(0.0, 1.0, 0.01) var _right_trigger_deadzone: float = 0.0
## Key to run.
@export var _run_key: Key = Key.KEY_SHIFT

@export_group("Left Stick", "_left_stick")
## Left Stick action name. LS to xbox and L to ps.
@export_placeholder("Left Stick action name") var _left_stick_action_name = "LS":
	set(value):
		if owner == null:
			_left_stick_action_name = value
			return
		_verify_duplicate(owner._actions_sticks, value)
		owner._actions_sticks.erase(_left_stick_action_name)
		_left_stick_action_name = value
		if value != "":
			owner._actions_sticks[_left_stick_action_name] = owner.get_left_stick
## Corresponding key of negative axis x stick.
@export var _left_stick_key_negative_x: Key = Key.KEY_A
## Corresponding key of positive axis x stick.
@export var _left_stick_key_positive_x: Key = Key.KEY_D
## Corresponding key of negative axis y stick.
@export var _left_stick_key_negative_y: Key = Key.KEY_W
## Corresponding key of positive axis y stick.
@export var _left_stick_key_positive_y: Key = Key.KEY_S

@export_group("Left Stick/UI", "_left_stick_ui")
@export var _left_stick_ui_visible: bool = true:
	set(value):
		_left_stick_ui_visible = value
		if is_instance_valid(owner):
			owner._left_stick_ui.visible = _left_stick_ui_visible
## Enables or disables the joystick input.
@export var _left_stick_ui_active: bool = true:
	set(value):
		_left_stick_ui_active = value
		if owner:
			owner._left_stick_ui.active = _left_stick_ui_active
## Deadzone threshold (0.0 = off, 1.0 = full range).
@export_range(0.0, 0.9, 0.001, "suffix:length") var _left_stick_ui_deadzone: float = 0.1:
	set(value):
		_left_stick_ui_deadzone = value
		if owner:
			owner._left_stick_ui.deadzone = _left_stick_ui_deadzone
			
## Global scale factor of the joystick.
@export var _left_stick_ui_position: Vector2 = Vector2(0, 0):
	set(value):
		_left_stick_ui_position = value
		if is_instance_valid(owner):
			owner._left_stick_ui.global_position = owner._position_left_stick_ui()

@export_range(0.1, 2.0, 0.001, "suffix:x", "or_greater") var _left_stick_ui_scale_factor: float = 1.0:
	set(value):
		_left_stick_ui_scale_factor = value
		if owner:
			owner._left_stick_ui.scale_factor = _left_stick_ui_scale_factor
			
## If true, the Joystick will only be displayed on the screen on mobile devices.
@export var _left_stick_ui_only_mobile: bool = false:
	set(value):
		_left_stick_ui_only_mobile = value
		if owner:
			owner._left_stick_ui.only_mobile = _left_stick_ui_only_mobile
			
## Enable the use of textures for the joystick.
@export var _left_stick_ui_joystick_use_textures: bool = true:
	set(value):
		_left_stick_ui_joystick_use_textures = value
		if owner:
			owner._left_stick_ui.joystick_use_textures = _left_stick_ui_joystick_use_textures

## Select one of the available models. More models will be available soon.
@export_enum("NONE", "PRESET_DEFAULT", "PRESET_2", "PRESET_3", "PRESET_4", "PRESET_5", "PRESET_6") var _left_stick_ui_joystick_preset_texture: int = 5:
	set(value):
		_left_stick_ui_joystick_preset_texture = value
		if owner:
			owner._left_stick_ui.joystick_preset_texture = _left_stick_ui_joystick_preset_texture
			match (value):
				1:
					_left_stick_ui_joystick_texture = _DEFAULT_JOYSTICK_TEXTURE
				2:
					_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_2
				3:
					_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_3
				4:
					_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_4
				55:
					_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_5
				6:
					_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_6
				0:
					if _left_stick_ui_joystick_texture in [_DEFAULT_JOYSTICK_TEXTURE, _JOYSTICK_TEXTURE_2, _JOYSTICK_TEXTURE_3, _JOYSTICK_TEXTURE_4, _JOYSTICK_TEXTURE_5, _JOYSTICK_TEXTURE_6]:
						_left_stick_ui_joystick_texture = null
			
## Select a texture for the joystick figure.
@export var _left_stick_ui_joystick_texture: Texture2D = _JOYSTICK_TEXTURE_5:
	set(value):
		_left_stick_ui_joystick_texture = value
		if owner:
			owner._left_stick_ui.joystick_texture = _left_stick_ui_joystick_texture
			
## Base color of the joystick background.
@export_color_no_alpha() var _left_stick_ui_joystick_color: Color = Color.WHITE:
	set(value):
		_left_stick_ui_joystick_color = value
		if owner:
			owner._left_stick_ui.joystick_color = _left_stick_ui_joystick_color
			
## Opacity of the joystick base.
@export_range(0.0, 1.0, 0.001, "suffix:alpha") var _left_stick_ui_joystick_opacity: float = 0.8:
	set(value):
		_left_stick_ui_joystick_opacity = value
		if owner:
			owner._left_stick_ui.joystick_opacity = _left_stick_ui_joystick_opacity
			
## Width of the joystick base border.
@export_range(1.0, 20.0, 0.01, "suffix:px", "or_greater") var _left_stick_ui_joystick_border: float = 1.0:
	set(value):
		_left_stick_ui_joystick_border = value
		if owner:
			owner._left_stick_ui.joystick_border = _left_stick_ui_joystick_border
			
## Enable the use of textures for the stick.
@export var _left_stick_ui_stick_use_textures: bool = true:
	set(value):
		_left_stick_ui_stick_use_textures = value
		if owner:
			owner._left_stick_ui.stick_use_textures = _left_stick_ui_stick_use_textures
			
## Select one of the available models. More models will be available soon.
@export_enum("NONE", "PRESET_DEFAULT", "PRESET_2", "PRESET_3", "PRESET_4", "PRESET_5", "PRESET_6") var _left_stick_ui_stick_preset_texture: int = 5:
	set(value):
		_left_stick_ui_stick_preset_texture = value
		if owner:
			owner._left_stick_ui.stick_preset_texture = _left_stick_ui_stick_preset_texture
			match (value):
				1:
					_left_stick_ui_stick_texture = _DEFAULT_STICK_TEXTURE
				2:
					_left_stick_ui_stick_texture = _STICK_TEXTURE_2
				3:
					_left_stick_ui_stick_texture = _STICK_TEXTURE_3
				4:
					_left_stick_ui_stick_texture = _STICK_TEXTURE_4
				5:
					_left_stick_ui_stick_texture = _STICK_TEXTURE_5
				6:
					_left_stick_ui_stick_texture = _STICK_TEXTURE_6
				0:
					if _left_stick_ui_stick_texture in [_DEFAULT_STICK_TEXTURE, _STICK_TEXTURE_2, _STICK_TEXTURE_3, _STICK_TEXTURE_4, _STICK_TEXTURE_5, _STICK_TEXTURE_6]:
						_left_stick_ui_stick_texture = null

			
## Select a texture for the stick figure.
@export var _left_stick_ui_stick_texture: Texture2D = _STICK_TEXTURE_5:
	set(value):
		_left_stick_ui_stick_texture = value
		if owner:
			owner._left_stick_ui.stick_texture = _left_stick_ui_stick_texture
			
## Stick (thumb) color.
@export_color_no_alpha() var _left_stick_ui_stick_color: Color = Color.WHITE:
	set(value):
		_left_stick_ui_stick_color = value
		if owner:
			owner._left_stick_ui.stick_color = _left_stick_ui_stick_color
			
## Opacity of the stick.
@export_range(0.0, 1.0, 0.001, "suffix:alpha") var _left_stick_ui_stick_opacity: float = 0.8:
	set(value):
		_left_stick_ui_stick_opacity = value
		if owner:
			owner._left_stick_ui.stick_opacity = _left_stick_ui_stick_opacity
			

@export_group("Right Stick", "_right_stick")
## Right Stick action name. RS to xbox and R to ps.
@export_placeholder("Right Stick action name") var _right_stick_action_name = "RS":
	set(value):
		if owner == null:
			_right_stick_action_name = value
			return
		_verify_duplicate(owner._actions_sticks, value)
		owner._actions_sticks.erase(_right_stick_action_name)
		_right_stick_action_name = value
		if value != "":
			owner._actions_sticks[_right_stick_action_name] = owner.get_right_stick
## Corresponding key of negative axis x stick.
@export var _right_stick_key_negative_x: Key = Key.KEY_J
## Corresponding key of positive axis x stick.
@export var _right_stick_key_positive_x: Key = Key.KEY_L
## Corresponding key of negative axis y stick.
@export var _right_stick_key_negative_y: Key = Key.KEY_I
## Corresponding key of positive axis y stick.
@export var _right_stick_key_positive_y: Key = Key.KEY_K


@export_group("Right Stick/UI", "_right_stick_ui")
@export var _right_stick_ui_visible: bool = true:
	set(value):
		_right_stick_ui_visible = value
		if is_instance_valid(owner):
			owner._right_stick_ui.visible = _right_stick_ui_visible
## Enables or disables the joystick input.
@export var _right_stick_ui_active: bool = true:
	set(value):
		_right_stick_ui_active = value
		if owner:
			owner._right_stick_ui.active = _right_stick_ui_active
## Deadzone threshold (0.0 = off, 1.0 = full range).
@export_range(0.0, 0.9, 0.001, "suffix:length") var _right_stick_ui_deadzone: float = 0.1:
	set(value):
		_right_stick_ui_deadzone = value
		if owner:
			owner._right_stick_ui.deadzone = _right_stick_ui_deadzone
			
## Global scale factor of the joystick.
@export var _right_stick_ui_position: Vector2 = Vector2(0, 0):
	set(value):
		_right_stick_ui_position = value
		if is_instance_valid(owner):
			owner._right_stick_ui.global_position = owner._position_right_stick_ui()
@export_range(0.1, 2.0, 0.001, "suffix:x", "or_greater") var _right_stick_ui_scale_factor: float = 1.0:
	set(value):
		_right_stick_ui_scale_factor = value
		if owner:
			owner._right_stick_ui.scale_factor = _right_stick_ui_scale_factor
			
## If true, the Joystick will only be displayed on the screen on mobile devices.
@export var _right_stick_ui_only_mobile: bool = false:
	set(value):
		_right_stick_ui_only_mobile = value
		if owner:
			owner._right_stick_ui.only_mobile = _right_stick_ui_only_mobile
			
## Enable the use of textures for the joystick.
@export var _right_stick_ui_joystick_use_textures: bool = true:
	set(value):
		_right_stick_ui_joystick_use_textures = value
		if owner:
			owner._right_stick_ui.joystick_use_textures = _right_stick_ui_joystick_use_textures
			
## Select one of the available models. More models will be available soon.
@export_enum("NONE", "PRESET_DEFAULT", "PRESET_2", "PRESET_3", "PRESET_4", "PRESET_5", "PRESET_6") var _right_stick_ui_joystick_preset_texture: int = 5:
	set(value):
		_right_stick_ui_joystick_preset_texture = value
		if owner:
			owner._right_stick_ui.joystick_preset_texture = _right_stick_ui_joystick_preset_texture
			match (value):
				1:
					_right_stick_ui_joystick_texture = _DEFAULT_JOYSTICK_TEXTURE
				2:
					_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_2
				3:
					_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_3
				4:
					_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_4
				55:
					_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_5
				6:
					_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_6
				0:
					if _right_stick_ui_joystick_texture in [_DEFAULT_JOYSTICK_TEXTURE, _JOYSTICK_TEXTURE_2, _JOYSTICK_TEXTURE_3, _JOYSTICK_TEXTURE_4, _JOYSTICK_TEXTURE_5, _JOYSTICK_TEXTURE_6]:
						_right_stick_ui_joystick_texture = null
			
## Select a texture for the joystick figure.
@export var _right_stick_ui_joystick_texture: Texture2D = _JOYSTICK_TEXTURE_5:
	set(value):
		_right_stick_ui_joystick_texture = value
		if owner:
			owner._right_stick_ui.joystick_texture = _right_stick_ui_joystick_texture
			
## Base color of the joystick background.
@export_color_no_alpha() var _right_stick_ui_joystick_color: Color = Color.WHITE:
	set(value):
		_right_stick_ui_joystick_color = value
		if owner:
			owner._right_stick_ui.joystick_color = _right_stick_ui_joystick_color
			
## Opacity of the joystick base.
@export_range(0.0, 1.0, 0.001, "suffix:alpha") var _right_stick_ui_joystick_opacity: float = 0.8:
	set(value):
		_right_stick_ui_joystick_opacity = value
		if owner:
			owner._right_stick_ui.joystick_opacity = _right_stick_ui_joystick_opacity
			
## Width of the joystick base border.
@export_range(1.0, 20.0, 0.01, "suffix:px", "or_greater") var _right_stick_ui_joystick_border: float = 1.0:
	set(value):
		_right_stick_ui_joystick_border = value
		if owner:
			owner._right_stick_ui.joystick_border = _right_stick_ui_joystick_border
			
## Enable the use of textures for the stick.
@export var _right_stick_ui_stick_use_textures: bool = true:
	set(value):
		_right_stick_ui_stick_use_textures = value
		if owner:
			owner._right_stick_ui.stick_use_textures = _right_stick_ui_stick_use_textures
			
## Select one of the available models. More models will be available soon.
@export_enum("NONE", "PRESET_DEFAULT", "PRESET_2", "PRESET_3", "PRESET_4", "PRESET_5", "PRESET_6") var _right_stick_ui_stick_preset_texture: int = 5:
	set(value):
		_right_stick_ui_stick_preset_texture = value
		if owner:
			owner._right_stick_ui.stick_preset_texture = _right_stick_ui_stick_preset_texture
			match (value):
				1:
					_right_stick_ui_stick_texture = _DEFAULT_STICK_TEXTURE
				2:
					_right_stick_ui_stick_texture = _STICK_TEXTURE_2
				3:
					_right_stick_ui_stick_texture = _STICK_TEXTURE_3
				4:
					_right_stick_ui_stick_texture = _STICK_TEXTURE_4
				5:
					_right_stick_ui_stick_texture = _STICK_TEXTURE_5
				6:
					_right_stick_ui_stick_texture = _STICK_TEXTURE_6
				0:
					if _right_stick_ui_stick_texture in [_DEFAULT_STICK_TEXTURE, _STICK_TEXTURE_2, _STICK_TEXTURE_3, _STICK_TEXTURE_4, _STICK_TEXTURE_5, _STICK_TEXTURE_6]:
						_right_stick_ui_stick_texture = null
			
## Select a texture for the stick figure.
@export var _right_stick_ui_stick_texture: Texture2D = _STICK_TEXTURE_5:
	set(value):
		_right_stick_ui_stick_texture = value
		if owner:
			owner._right_stick_ui.stick_texture = _right_stick_ui_stick_texture
			
## Stick (thumb) color.
@export_color_no_alpha() var _right_stick_ui_stick_color: Color = Color.WHITE:
	set(value):
		_right_stick_ui_stick_color = value
		if owner:
			owner._right_stick_ui.stick_color = _right_stick_ui_stick_color
			
## Opacity of the stick.
@export_range(0.0, 1.0, 0.001, "suffix:alpha") var _right_stick_ui_stick_opacity: float = 0.8:
	set(value):
		_right_stick_ui_stick_opacity = value
		if owner:
			owner._right_stick_ui.stick_opacity = _right_stick_ui_stick_opacity
	
@export_group("Left Trigger", "_left_trigger")
## Left Trigger action name. LT to xbox and L2 to ps.
@export_placeholder("Left Trigger action name") var _left_trigger_action_name = "LT":
	set(value):
		if owner == null:
			_left_trigger_action_name = value
			return
		_verify_duplicate(owner._actions_triggers, value)
		owner._actions_triggers.erase(_left_trigger_action_name)
		_left_trigger_action_name = value
		if value != "":
			owner._actions_triggers[_left_trigger_action_name] = owner.get_left_trigger
## Corresponding key.
@export var _left_trigger_key: Key = Key.KEY_Q
## Corresponding mouse button.
@export var _left_trigger_mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_LEFT
@export_group("Left Trigger/UI", "_left_trigger")
@export var _left_trigger_touch_visible: bool = true:
	set(value):
		_left_trigger_touch_visible = value
		if is_instance_valid(owner):
			owner._button_left_trigger_touch.visible = _left_trigger_touch_visible
@export var _left_trigger_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/lt_normal.png"):
	set(value):
		_left_trigger_texture_normal = value
		if is_instance_valid(owner):
			owner._button_left_trigger_touch.texture_normal = _left_trigger_texture_normal
@export var _left_trigger_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/lt_pressed.png"):
	set(value):
		_left_trigger_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_left_trigger_touch.texture_pressed = _left_trigger_texture_pressed
@export var _left_trigger_position: Vector2 = Vector2(0, 0):
	set(value):
		_left_trigger_position = value
		if is_instance_valid(owner):
			owner._button_left_trigger_touch.global_position = owner._position_button_left_trigger_touch()

@export_group("Right Trigger", "_right_trigger")
## Right Trigger action name. RT to xbox and R2 to ps.
@export_placeholder("Right Trigger action name") var _right_trigger_action_name = "RT":
	set(value):
		if owner == null:
			_right_trigger_action_name = value
			return
		_verify_duplicate(owner._actions_triggers, value)
		owner._actions_triggers.erase(_right_trigger_action_name)
		_right_trigger_action_name = value
		if value != "":
			owner._actions_triggers[_right_trigger_action_name] = owner.get_right_trigger
## Corresponding key.
@export var _right_trigger_key: Key = Key.KEY_E
## Corresponding mouse button.
@export var _right_trigger_mouse_button: MouseButton = MouseButton.MOUSE_BUTTON_RIGHT
@export_group("Right Trigger/UI", "_right_trigger")
@export var _right_trigger_touch_visible: bool = true:
	set(value):
		_right_trigger_touch_visible = value
		if is_instance_valid(owner):
			owner._button_right_trigger_touch.visible = _right_trigger_touch_visible
@export var _right_trigger_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/rt_normal.png"):
	set(value):
		_right_trigger_texture_normal = value
		if is_instance_valid(owner):
			owner._button_right_trigger_touch.texture_normal = _right_trigger_texture_normal
@export var _right_trigger_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/rt_pressed.png"):
	set(value):
		_right_trigger_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_right_trigger_touch.texture_pressed = _right_trigger_texture_pressed
@export var _right_trigger_position: Vector2 = Vector2(0, 0):
	set(value):
		_right_trigger_position = value
		if is_instance_valid(owner):
			owner._button_right_trigger_touch.global_position = owner._position_button_right_trigger_touch()

@export_group("Left Shoulder", "_left_shoulder")
## Button Left Shoulder of joystick action name. LB to xbox and L1 to ps.
@export_placeholder("Left Shoulder action name") var _left_shoulder_action_name = "LB":
	set(value):
		if owner == null:
			_left_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_left_shoulder_action_name)
		_left_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Button Left Shoulder event action.
@export var _left_shoulder_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_left_shoulder_type = value
			return
		owner._actions_buttons.erase(_left_shoulder_action_name)
		_left_shoulder_type = value
		if _left_shoulder_action_name != "":
			owner._actions_buttons[_left_shoulder_action_name] = \
			owner.get_left_shoulder_pressed if _left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_shoulder_realesed if _left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_shoulder_oneshot if _left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_shoulder_toggle
## Corresponding key.
@export var _left_shoulder_key: Key = Key.KEY_U
@export_group("Left Shoulder/UI", "_left_shoulder")
@export var _left_shoulder_touch_visible: bool = true:
	set(value):
		_left_shoulder_touch_visible = value
		if is_instance_valid(owner):
			owner._button_left_shoulder_touch.visible = _left_shoulder_touch_visible
@export var _left_shoulder_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/lb_normal.png"):
	set(value):
		_left_shoulder_texture_normal = value
		if is_instance_valid(owner):
			owner._button_left_shoulder_touch.texture_normal = _left_shoulder_texture_normal
@export var _left_shoulder_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/lb_pressed.png"):
	set(value):
		_left_shoulder_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_left_shoulder_touch.texture_pressed = _left_shoulder_texture_pressed
@export var _left_shoulder_position: Vector2 = Vector2(0, 0):
	set(value):
		_left_shoulder_position = value
		if is_instance_valid(owner):
			owner._button_left_shoulder_touch.global_position = owner._position_button_left_shoulder_touch()

@export_group("Right Shoulder", "_right_shoulder")
## Button Right Shoulder of joystick action name. RB to xbox and R1 to ps.
@export_placeholder("Right Shoulder action name") var _right_shoulder_action_name = "RB":
	set(value):
		if owner == null:
			_right_shoulder_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_right_shoulder_action_name)
		_right_shoulder_action_name = value
		if value != "":
			owner._actions_buttons[_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Button Right Shoulder event action.
@export var _right_shoulder_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_right_shoulder_type = value
			return
		owner._actions_buttons.erase(_right_shoulder_action_name)
		_right_shoulder_type = value
		if _right_shoulder_action_name != "":
			owner._actions_buttons[_right_shoulder_action_name] = \
			owner.get_right_shoulder_pressed if _right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_shoulder_realesed if _right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_shoulder_oneshot if _right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_shoulder_toggle
## Corresponding key.
@export var _right_shoulder_key: Key = Key.KEY_O
@export_group("Right Shoulder/UI", "_right_shoulder")
@export var _right_shoulder_touch_visible: bool = true:
	set(value):
		_right_shoulder_touch_visible = value
		if is_instance_valid(owner):
			owner._button_right_shoulder_touch.visible = _right_shoulder_touch_visible
@export var _right_shoulder_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/rb_normal.png"):
	set(value):
		_right_shoulder_texture_normal = value
		if is_instance_valid(owner):
			owner._button_right_shoulder_touch.texture_normal = _right_shoulder_texture_normal
@export var _right_shoulder_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/rb_pressed.png"):
	set(value):
		_right_shoulder_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_right_shoulder_touch.texture_pressed = _right_shoulder_texture_pressed
@export var _right_shoulder_position: Vector2 = Vector2(0, 0):
	set(value):
		_right_shoulder_position = value
		if is_instance_valid(owner):
			owner._button_right_shoulder_touch.global_position = owner._position_button_right_shoulder_touch()

@export_group("Action Button Left Stick", "_left_stick_button")
## Button joystick action name. LSB to xbox and L3 to ps.
@export_placeholder("Button L3 action name") var _left_stick_button_action_name = "LSB":
	set(value):
		if owner == null:
			_left_stick_button_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_left_stick_button_action_name)
		_left_stick_button_action_name = value
		if value != "":
			owner._actions_buttons[_left_stick_button_action_name] = \
			owner.get_left_stick_button_pressed if _left_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _left_stick_button_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _left_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Button L3 event action.
@export var _left_stick_button_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_left_stick_button_type = value
			return
		owner._actions_buttons.erase(_left_stick_button_action_name)
		_left_stick_button_type = value
		if _left_stick_button_action_name != "":
			owner._actions_buttons[_left_stick_button_action_name] = \
			owner.get_left_stick_button_pressed if _left_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_left_stick_button_realesed if _left_stick_button_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_left_stick_button_oneshot if _left_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_left_stick_button_toggle
## Corresponding key.
@export var _left_stick_button_key: Key = Key.KEY_F
@export_group("Action Button Left Stick/UI", "_left_stick_button")
@export var _left_stick_button_touch_visible: bool = true:
	set(value):
		_left_stick_button_touch_visible = value
		if is_instance_valid(owner):
			owner._button_button_left_stick_touch.visible = _left_stick_button_touch_visible
@export var _left_stick_button_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/left_stick_button_normal.png"):
	set(value):
		_left_stick_button_texture_normal = value
		if is_instance_valid(owner):
			owner._button_button_left_stick_touch.texture_normal = _left_stick_button_texture_normal
@export var _left_stick_button_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/left_stick_button_normal.png"):
	set(value):
		_left_stick_button_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_button_left_stick_touch.texture_pressed = _left_stick_button_texture_pressed
@export var _left_stick_button_position: Vector2 = Vector2(0, 0):
	set(value):
		_left_stick_button_position = value
		if is_instance_valid(owner):
			owner._button_button_left_stick_touch.global_position = owner._position_button_left_stick_touch()

@export_group("Action Button Right Stick", "_right_stick_button")
## Button joystick action name. RSB to xbox and R3 to ps.
@export_placeholder("Button R3 action name") var _right_stick_button_action_name = "RSB":
	set(value):
		if owner == null:
			_right_stick_button_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_right_stick_button_action_name)
		_right_stick_button_action_name = value
		if value != "":
			owner._actions_buttons[_right_stick_button_action_name] = \
			owner.get_right_stick_button_pressed if _right_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _right_stick_button_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _right_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Button R3 event action.
@export var _right_stick_button_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_right_stick_button_type = value
			return
		owner._actions_buttons.erase(_right_stick_button_action_name)
		_right_stick_button_type = value
		if _right_stick_button_action_name != "":
			owner._actions_buttons[_right_stick_button_action_name] = \
			owner.get_right_stick_button_pressed if _right_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_right_stick_button_realesed if _right_stick_button_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_right_stick_button_oneshot if _right_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_right_stick_button_toggle
## Corresponding key.
@export var _right_stick_button_key: Key = Key.KEY_G
@export_group("Action Button Right Stick/UI", "_right_stick_button")
@export var _right_stick_button_touch_visible: bool = true:
	set(value):
		_right_stick_button_touch_visible = value
		if is_instance_valid(owner):
			owner._button_button_right_stick_touch.visible = _right_stick_button_touch_visible
@export var _right_stick_button_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/right_stick_button_normal.png"):
	set(value):
		_right_stick_button_texture_normal = value
		if is_instance_valid(owner):
			owner._button_button_right_stick_touch.texture_normal = _right_stick_button_texture_normal
@export var _right_stick_button_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/right_stick_button_normal.png"):
	set(value):
		_right_stick_button_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_button_right_stick_touch.texture_pressed = _right_stick_button_texture_pressed
@export var _right_stick_button_position: Vector2 = Vector2(0, 0):
	set(value):
		_right_stick_button_position = value
		if is_instance_valid(owner):
			owner._button_button_right_stick_touch.global_position = owner._position_button_right_stick_touch()

@export_group("Action Button A", "_button_a")
## Button A (Xbox) or X (PS) of joystick action name.
@export_placeholder("Button A action name") var _button_a_action_name = "A":
	set(value):
		if owner == null:
			_button_a_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_a_action_name)
		_button_a_action_name = value
		if value != "":
			owner._actions_buttons[_button_a_action_name] = \
			owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Button A event action.
@export var _button_a_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_a_type = value
			return
		owner._actions_buttons.erase(_button_a_action_name)
		_button_a_type = value
		if _button_a_action_name != "":
			owner._actions_buttons[_button_a_action_name] = \
			owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_a_toggle
## Corresponding key.
@export var _button_a_key: Key = Key.KEY_SPACE
@export_group("Action Button A/UI", "_button_a")
@export var _button_a_touch_visible: bool = true:
	set(value):
		_button_a_touch_visible = value
		if is_instance_valid(owner):
			owner._button_a_touch.visible = _button_a_touch_visible
@export var _button_a_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/a_normal.png"):
	set(value):
		_button_a_texture_normal = value
		if is_instance_valid(owner):
			owner._button_a_touch.texture_normal = _button_a_texture_normal
@export var _button_a_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/a_pressed.png"):
	set(value):
		_button_a_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_a_touch.texture_pressed = _button_a_texture_pressed
@export var _button_a_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_a_position = value
		if is_instance_valid(owner):
			owner._button_a_touch.global_position = owner._position_button_a_touch()

@export_group("Action Button B", "_button_b")
## Button B (Xbox) or Circle (PS) of joystick action name.
@export_placeholder("Button B action name") var _button_b_action_name = "B":
	set(value):
		if owner == null:
			_button_b_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_b_action_name)
		_button_b_action_name = value
		if value != "":
			owner._actions_buttons[_button_b_action_name] = \
			owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Button B event action.
@export var _button_b_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_b_type = value
			return
		owner._actions_buttons.erase(_button_b_action_name)
		_button_b_type = value
		if _button_b_action_name != "":
			owner._actions_buttons[_button_b_action_name] = \
			owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_b_toggle
## Corresponding key.
@export var _button_b_key: Key = Key.KEY_Z
@export_group("Action Button B/UI", "_button_b")
@export var _button_b_touch_visible: bool = true:
	set(value):
		_button_b_touch_visible = value
		if is_instance_valid(owner):
			owner._button_b_touch.visible = _button_b_touch_visible
@export var _button_b_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/b_normal.png"):
	set(value):
		_button_b_texture_normal = value
		if is_instance_valid(owner):
			owner._button_b_touch.texture_normal = _button_b_texture_normal
@export var _button_b_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/b_pressed.png"):
	set(value):
		_button_b_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_b_touch.texture_pressed = _button_b_texture_pressed
@export var _button_b_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_b_position = value
		if is_instance_valid(owner):
			owner._button_b_touch.global_position = owner._position_button_b_touch()

@export_group("Action Button X", "_button_x")
## Button X (Xbox) or Square (PS) of joystick action name.
@export_placeholder("Button X action name") var _button_x_action_name = "X":
	set(value):
		if owner == null:
			_button_x_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_x_action_name)
		_button_x_action_name = value
		if value != "":
			owner._actions_buttons[_button_x_action_name] = \
			owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Button X event action.
@export var _button_x_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_x_type = value
			return
		owner._actions_buttons.erase(_button_x_action_name)
		_button_x_type = value
		if _button_x_action_name != "":
			owner._actions_buttons[_button_x_action_name] = \
			owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_x_toggle
## Corresponding key.
@export var _button_x_key: Key = Key.KEY_X
@export_group("Action Button X/UI", "_button_x")
@export var _button_x_touch_visible: bool = true:
	set(value):
		_button_x_touch_visible = value
		if is_instance_valid(owner):
			owner._button_x_touch.visible = _button_x_touch_visible
@export var _button_x_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/x_normal.png"):
	set(value):
		_button_x_texture_normal = value
		if is_instance_valid(owner):
			owner._button_x_touch.texture_normal = _button_x_texture_normal
@export var _button_x_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/x_pressed.png"):
	set(value):
		_button_x_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_x_touch.texture_pressed = _button_x_texture_pressed
@export var _button_x_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_x_position = value
		if is_instance_valid(owner):
			owner._button_x_touch.global_position = owner._position_button_x_touch()

@export_group("Action Button Y", "_button_y")
## Button Y (Xbox) or Triangle (PS) of joystick action name.
@export_placeholder("Button Y action name") var _button_y_action_name = "Y":
	set(value):
		if owner == null:
			_button_y_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_y_action_name)
		_button_y_action_name = value
		if value != "":
			owner._actions_buttons[_button_y_action_name] = \
			owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Button Y event action.
@export var _button_y_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_y_type = value
			return
		owner._actions_buttons.erase(_button_y_action_name)
		_button_y_type = value
		if _button_y_action_name != "":
			owner._actions_buttons[_button_y_action_name] = \
			owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_button_y_toggle
## Corresponding key.
@export var _button_y_key: Key = Key.KEY_C
@export_group("Action Button Y/UI", "_button_y")
@export var _button_y_touch_visible: bool = true:
	set(value):
		_button_y_touch_visible = value
		if is_instance_valid(owner):
			owner._button_y_touch.visible = _button_y_touch_visible
@export var _button_y_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/y_normal.png"):
	set(value):
		_button_y_texture_normal = value
		if is_instance_valid(owner):
			owner._button_y_touch.texture_normal = _button_y_texture_normal
@export var _button_y_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/y_pressed.png"):
	set(value):
		_button_y_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_y_touch.texture_pressed = _button_y_texture_pressed
@export var _button_y_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_y_position = value
		if is_instance_valid(owner):
			owner._button_y_touch.global_position = owner._position_button_y_touch()

@export_group("Action Button D-PAD UP", "_button_dpad_up")
## Button D-PAD UP of joystick action name.
@export_placeholder("Button D-PAD UP action name") var _button_dpad_up_action_name = "D_PAD_UP":
	set(value):
		if owner == null:
			_button_dpad_up_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_up_action_name)
		_button_dpad_up_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Button D-PAD UP event action.
@export var _button_dpad_up_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_up_type = value
			return
		owner._actions_buttons.erase(_button_dpad_up_action_name)
		_button_dpad_up_type = value
		if _button_dpad_up_action_name != "":
			owner._actions_buttons[_button_dpad_up_action_name] = \
			owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_up_toggle
## Corresponding key.
@export var _button_dpad_up_key: Key = Key.KEY_UP
@export_group("Action Button D-PAD UP/UI", "_button_dpad_up")
@export var _button_dpad_up_touch_visible: bool = true:
	set(value):
		_button_dpad_up_touch_visible = value
		if is_instance_valid(owner):
			owner._button_dpad_up_touch.visible = _button_dpad_up_touch_visible
@export var _button_dpad_up_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_up_normal.png"):
	set(value):
		_button_dpad_up_texture_normal = value
		if is_instance_valid(owner):
			owner._button_dpad_up_touch.texture_normal = _button_dpad_up_texture_normal
@export var _button_dpad_up_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_up_pressed.png"):
	set(value):
		_button_dpad_up_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_dpad_up_touch.texture_pressed = _button_dpad_up_texture_pressed
@export var _button_dpad_up_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_dpad_up_position = value
		if is_instance_valid(owner):
			owner._button_dpad_up_touch.global_position = owner._position_button_dpad_up_touch()

@export_group("Action Button D-PAD DOWN", "_button_dpad_down")
## Button D-PAD DOWN of joystick action name.
@export_placeholder("Button D-PAD DOWN action name") var _button_dpad_down_action_name = "D_PAD_DOWN":
	set(value):
		if owner == null:
			_button_dpad_down_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_down_action_name)
		_button_dpad_down_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Button D-PAD DOWN event action.
@export var _button_dpad_down_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_down_type = value
			return
		owner._actions_buttons.erase(_button_dpad_down_action_name)
		_button_dpad_down_type = value
		if _button_dpad_down_action_name != "":
			owner._actions_buttons[_button_dpad_down_action_name] = \
			owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_down_toggle
## Corresponding key.
@export var _button_dpad_down_key: Key = Key.KEY_DOWN
@export_group("Action Button D-PAD DOWN/UI", "_button_dpad_down")
@export var _button_dpad_down_touch_visible: bool = true:
	set(value):
		_button_dpad_down_touch_visible = value
		if is_instance_valid(owner):
			owner._button_dpad_down_touch.visible = _button_dpad_down_touch_visible
@export var _button_dpad_down_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_down_normal.png"):
	set(value):
		_button_dpad_down_texture_normal = value
		if is_instance_valid(owner):
			owner._button_dpad_down_touch.texture_normal = _button_dpad_down_texture_normal
@export var _button_dpad_down_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_down_pressed.png"):
	set(value):
		_button_dpad_down_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_dpad_down_touch.texture_pressed = _button_dpad_down_texture_pressed
@export var _button_dpad_down_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_dpad_down_position = value
		if is_instance_valid(owner):
			owner._button_dpad_down_touch.global_position = owner._position_button_dpad_down_touch()

@export_group("Action Button D-PAD LEFT", "_button_dpad_left")
## Button D-PAD LEFT of joystick action name.
@export_placeholder("Button D-PAD LEFT action name") var _button_dpad_left_action_name = "D_PAD_LEFT":
	set(value):
		if owner == null:
			_button_dpad_left_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_left_action_name)
		_button_dpad_left_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Button D-PAD LEFT event action.
@export var _button_dpad_left_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_left_type = value
			return
		owner._actions_buttons.erase(_button_dpad_left_action_name)
		_button_dpad_left_type = value
		if _button_dpad_left_action_name != "":
			owner._actions_buttons[_button_dpad_left_action_name] = \
			owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_left_toggle
## Corresponding key.
@export var _button_dpad_left_key: Key = Key.KEY_LEFT
@export_group("Action Button D-PAD LEFT/UI", "_button_dpad_left")
@export var _button_dpad_left_touch_visible: bool = true:
	set(value):
		_button_dpad_left_touch_visible = value
		if is_instance_valid(owner):
			owner._button_dpad_left_touch.visible = _button_dpad_left_touch_visible
@export var _button_dpad_left_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_left_normal.png"):
	set(value):
		_button_dpad_left_texture_normal = value
		if is_instance_valid(owner):
			owner._button_dpad_left_touch.texture_normal = _button_dpad_left_texture_normal
@export var _button_dpad_left_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_left_pressed.png"):
	set(value):
		_button_dpad_left_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_dpad_left_touch.texture_pressed = _button_dpad_left_texture_pressed
@export var _button_dpad_left_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_dpad_left_position = value
		if is_instance_valid(owner):
			owner._button_dpad_left_touch.global_position = owner._position_button_dpad_left_touch()

@export_group("Action Button D-PAD RIGHT", "_button_dpad_right")
## Button D-PAD RIGHT of joystick action name.
@export_placeholder("Button D-PAD RIGHT action name") var _button_dpad_right_action_name = "D_PAD_RIGHT":
	set(value):
		if owner == null:
			_button_dpad_right_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_dpad_right_action_name)
		_button_dpad_right_action_name = value
		if value != "":
			owner._actions_buttons[_button_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Button D-PAD RIGHT event action.
@export var _button_dpad_right_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_dpad_right_type = value
			return
		owner._actions_buttons.erase(_button_dpad_right_action_name)
		_button_dpad_right_type = value
		if _button_dpad_right_action_name != "":
			owner._actions_buttons[_button_dpad_right_action_name] = \
			owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_dpad_right_toggle
## Corresponding key.
@export var _button_dpad_right_key: Key = Key.KEY_RIGHT
@export_group("Action Button D-PAD RIGHT/UI", "_button_dpad_right")
@export var _button_dpad_right_touch_visible: bool = true:
	set(value):
		_button_dpad_right_touch_visible = value
		if is_instance_valid(owner):
			owner._button_dpad_right_touch.visible = _button_dpad_right_touch_visible
@export var _button_dpad_right_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_right_normal.png"):
	set(value):
		_button_dpad_right_texture_normal = value
		if is_instance_valid(owner):
			owner._button_dpad_right_touch.texture_normal = _button_dpad_right_texture_normal
@export var _button_dpad_right_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/d_pad_right_pressed.png"):
	set(value):
		_button_dpad_right_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_dpad_right_touch.texture_pressed = _button_dpad_right_texture_pressed
@export var _button_dpad_right_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_dpad_right_position = value
		if is_instance_valid(owner):
			owner._button_dpad_right_touch.global_position = owner._position_button_dpad_right_touch()

@export_group("Action Button Start", "_button_start")
## Button Start of joystick action name. Start to xbox and Options to ps.
@export_placeholder("Button Start action name") var _button_start_action_name = "START":
	set(value):
		if owner == null:
			_button_start_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_start_action_name)
		_button_start_action_name = value
		if value != "":
			owner._actions_buttons[_button_start_action_name] = \
			owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Button Start event action
@export var _button_start_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_start_type = value
			return
		owner._actions_buttons.erase(_button_start_action_name)
		_button_start_type = value
		if _button_start_action_name != "":
			owner._actions_buttons[_button_start_action_name] = \
			owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_start_toggle
## Corresponding key.
@export var _button_start_key: Key = Key.KEY_ENTER
@export_group("Action Button Start/UI", "_button_start")
@export var _button_start_touch_visible: bool = true:
	set(value):
		_button_start_touch_visible = value
		if is_instance_valid(owner):
			owner._button_start_touch.visible = _button_start_touch_visible
@export var _button_start_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/start_normal.png"):
	set(value):
		_button_start_texture_normal = value
		if is_instance_valid(owner):
			owner._button_start_touch.texture_normal = _button_start_texture_normal
@export var _button_start_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/start_pressed.png"):
	set(value):
		_button_start_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_start_touch.texture_pressed = _button_start_texture_pressed
@export var _button_start_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_start_position = value
		if is_instance_valid(owner):
			owner._button_start_touch.global_position = owner._position_button_start_touch()

@export_group("Action Button Select", "_button_select")
## Button Select of joystick action name. Back to xbox and Share to ps.
@export_placeholder("Button Select action name") var _button_select_action_name = "BACK":
	set(value):
		if owner == null:
			_button_select_action_name = value
			return
		_verify_duplicate(owner._actions_buttons, value)
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_action_name = value
		if value != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Button Select event action.
@export var _button_select_type: InputManagerConst._event_type_enum = InputManagerConst._event_type_enum.PRESSED:
	set(value):
		if owner == null:
			_button_select_type = value
			return
		owner._actions_buttons.erase(_button_select_action_name)
		_button_select_type = value
		if _button_select_action_name != "":
			owner._actions_buttons[_button_select_action_name] = \
			owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
			else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
			else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
			else owner.get_select_toggle
## Corresponding key.
@export var _button_select_key: Key = Key.KEY_BACKSPACE
@export_group("Action Button Select/UI", "_button_select")
@export var _button_select_touch_visible: bool = true:
	set(value):
		_button_select_touch_visible = value
		if is_instance_valid(owner):
			owner._button_select_touch.visible = _button_select_touch_visible
@export var _button_select_texture_normal: CompressedTexture2D = load("res://addons/input_manager/textures/menu_normal.png"):
	set(value):
		_button_select_texture_normal = value
		if is_instance_valid(owner):
			owner._button_select_touch.texture_normal = _button_select_texture_normal
@export var _button_select_texture_pressed: CompressedTexture2D = load("res://addons/input_manager/textures/menu_normal.png"):
	set(value):
		_button_select_texture_pressed = value
		if is_instance_valid(owner):
			owner._button_select_touch.texture_pressed = _button_select_texture_pressed
@export var _button_select_position: Vector2 = Vector2(0, 0):
	set(value):
		_button_select_position = value
		if is_instance_valid(owner):
			owner._button_select_touch.global_position = owner._position_button_select_touch()

@export_group("Mouse", "_mouse")
## If true, mouse events will be emitted, and if false, mouse-related events will only be triggered if the mouse is [b]captured[/b].
@export var _mouse_enable_event_without_captured: bool = false
## Button capture mouse.
@export var _mouse_capture_key: Key = Key.KEY_TAB
## Button mouse visible.
@export var _mouse_visble_key: Key = Key.KEY_ESCAPE

@export_group("")
@export_tool_button("RESET TO DEFAULT") var _reset_button = _on_reset_button


func init(_owner: InputManager) -> void:
	owner = _owner

	if owner == null:
		return

	owner._actions_buttons.clear()
	owner._actions_sticks.clear()
	owner._actions_triggers.clear()

	if _left_stick_action_name != "":
		_verify_duplicate(owner._actions_sticks, _left_stick_action_name)
		owner._actions_sticks[_left_stick_action_name] = owner.get_left_stick

	if _right_stick_action_name != "":
		_verify_duplicate(owner._actions_sticks, _right_stick_action_name)
		owner._actions_sticks[_right_stick_action_name] = owner.get_right_stick

	if _left_trigger_action_name != "":
		_verify_duplicate(owner._actions_triggers, _left_trigger_action_name)
		owner._actions_triggers[_left_trigger_action_name] = owner.get_left_trigger

	if _right_trigger_action_name != "":
		_verify_duplicate(owner._actions_triggers, _right_trigger_action_name)
		owner._actions_triggers[_right_trigger_action_name] = owner.get_right_trigger

	if _left_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _left_shoulder_action_name)
		owner._actions_buttons[_left_shoulder_action_name] = \
		owner.get_left_shoulder_pressed if _left_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_left_shoulder_realesed if _left_shoulder_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_left_shoulder_oneshot if _left_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_left_shoulder_toggle

	if _right_shoulder_action_name != "":
		_verify_duplicate(owner._actions_buttons, _right_shoulder_action_name)
		owner._actions_buttons[_right_shoulder_action_name] = \
		owner.get_right_shoulder_pressed if _right_shoulder_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_right_shoulder_realesed if _right_shoulder_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_right_shoulder_oneshot if _right_shoulder_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_right_shoulder_toggle

	if _left_stick_button_action_name != "":
		_verify_duplicate(owner._actions_buttons, _left_stick_button_action_name)
		owner._actions_buttons[_left_stick_button_action_name] = \
		owner.get_left_stick_button_pressed if _left_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_left_stick_button_realesed if _left_stick_button_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_left_stick_button_oneshot if _left_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_left_stick_button_toggle

	if _right_stick_button_action_name != "":
		_verify_duplicate(owner._actions_buttons, _right_stick_button_action_name)
		owner._actions_buttons[_right_stick_button_action_name] = \
		owner.get_right_stick_button_pressed if _right_stick_button_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_right_stick_button_realesed if _right_stick_button_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_right_stick_button_oneshot if _right_stick_button_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_right_stick_button_toggle

	if _button_a_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_a_action_name)
		owner._actions_buttons[_button_a_action_name] = \
		owner.get_button_a_pressed if _button_a_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_a_realesed if _button_a_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_a_oneshot if _button_a_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_a_toggle

	if _button_b_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_b_action_name)
		owner._actions_buttons[_button_b_action_name] = \
		owner.get_button_b_pressed if _button_b_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_b_realesed if _button_b_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_b_oneshot if _button_b_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_b_toggle

	if _button_x_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_x_action_name)
		owner._actions_buttons[_button_x_action_name] = \
		owner.get_button_x_pressed if _button_x_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_x_realesed if _button_x_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_x_oneshot if _button_x_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_x_toggle

	if _button_y_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_y_action_name)
		owner._actions_buttons[_button_y_action_name] = \
		owner.get_button_y_pressed if _button_y_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_button_y_realesed if _button_y_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_button_y_oneshot if _button_y_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_button_y_toggle

	if _button_dpad_up_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_up_action_name)
		owner._actions_buttons[_button_dpad_up_action_name] = \
		owner.get_dpad_up_pressed if _button_dpad_up_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_up_realesed if _button_dpad_up_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_up_oneshot if _button_dpad_up_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_up_toggle

	if _button_dpad_down_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_down_action_name)
		owner._actions_buttons[_button_dpad_down_action_name] = \
		owner.get_dpad_down_pressed if _button_dpad_down_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_down_realesed if _button_dpad_down_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_down_oneshot if _button_dpad_down_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_down_toggle

	if _button_dpad_left_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_left_action_name)
		owner._actions_buttons[_button_dpad_left_action_name] = \
		owner.get_dpad_left_pressed if _button_dpad_left_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_left_realesed if _button_dpad_left_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_left_oneshot if _button_dpad_left_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_left_toggle

	if _button_dpad_right_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_dpad_right_action_name)
		owner._actions_buttons[_button_dpad_right_action_name] = \
		owner.get_dpad_right_pressed if _button_dpad_right_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_dpad_right_realesed if _button_dpad_right_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_dpad_right_oneshot if _button_dpad_right_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_dpad_right_toggle

	if _button_start_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_start_action_name)
		owner._actions_buttons[_button_start_action_name] = \
		owner.get_start_pressed if _button_start_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_start_realesed if _button_start_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_start_oneshot if _button_start_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_start_toggle

	if _button_select_action_name != "":
		_verify_duplicate(owner._actions_buttons, _button_select_action_name)
		owner._actions_buttons[_button_select_action_name] = \
		owner.get_select_pressed if _button_select_type == InputManagerConst._event_type_enum.PRESSED \
		else owner.get_select_realesed if _button_select_type == InputManagerConst._event_type_enum.RELESED \
		else owner.get_select_oneshot if _button_select_type == InputManagerConst._event_type_enum.ONE_SHOT \
		else owner.get_select_toggle


func _verify_duplicate(_actions_source: Dictionary, value: String) -> void:
	if _actions_source.has(value):
		push_error("Action name %s duplicate."%value)


func _on_reset_button() -> void:
	_device = 0
	_left_stick_deadzone = 0.2
	_right_stick_deadzone = 0.2
	_left_trigger_deadzone = 0.0
	_right_trigger_deadzone = 0.0
	
	if _left_stick_action_name != "LS":
		_left_stick_action_name = "LS"
	_left_stick_key_negative_x = KEY_A
	_left_stick_key_positive_x = KEY_D
	_left_stick_key_negative_y = KEY_W
	_left_stick_key_positive_y = KEY_S
	_left_stick_ui_active = true
	_left_stick_ui_visible = true
	_left_stick_ui_deadzone = 0.1
	_left_stick_ui_position = Vector2.ZERO
	_left_stick_ui_scale_factor = 1.0
	_left_stick_ui_only_mobile = false
	_left_stick_ui_joystick_use_textures = true
	_left_stick_ui_joystick_preset_texture = 5
	_left_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_5
	_left_stick_ui_joystick_color = Color.WHITE
	_left_stick_ui_joystick_opacity = 0.8
	_left_stick_ui_joystick_border = 1.0
	_left_stick_ui_stick_use_textures = true
	_left_stick_ui_stick_preset_texture = 5
	_left_stick_ui_stick_texture = _STICK_TEXTURE_5
	_left_stick_ui_stick_color = Color.WHITE
	_left_stick_ui_stick_opacity = 0.8
	
	if _right_stick_action_name != "RS":
		_right_stick_action_name = "RS"
	_right_stick_key_negative_x = KEY_J
	_right_stick_key_positive_x = KEY_L
	_right_stick_key_negative_y = KEY_I
	_right_stick_key_positive_y = KEY_K
	_right_stick_ui_active = true
	_right_stick_ui_visible = true
	_right_stick_ui_deadzone = 0.1
	_right_stick_ui_position = Vector2.ZERO
	_right_stick_ui_scale_factor = 1.0
	_right_stick_ui_only_mobile = false
	_right_stick_ui_joystick_use_textures = true
	_right_stick_ui_joystick_preset_texture = 5
	_right_stick_ui_joystick_texture = _JOYSTICK_TEXTURE_5
	_right_stick_ui_joystick_color = Color.WHITE
	_right_stick_ui_joystick_opacity = 0.8
	_right_stick_ui_joystick_border = 1.0
	_right_stick_ui_stick_use_textures = true
	_right_stick_ui_stick_preset_texture = 5
	_right_stick_ui_stick_texture = _STICK_TEXTURE_5
	_right_stick_ui_stick_color = Color.WHITE
	_right_stick_ui_stick_opacity = 0.8
	
	if _left_trigger_action_name != "LT":
		_left_trigger_action_name = "LT"
	_left_trigger_key = Key.KEY_Q
	_left_trigger_mouse_button = MouseButton.MOUSE_BUTTON_LEFT
	_left_trigger_touch_visible = true
	_left_trigger_texture_normal = load("res://addons/input_manager/textures/lt_normal.png")
	_left_trigger_texture_pressed = load("res://addons/input_manager/textures/lt_pressed.png")
	_left_trigger_position = Vector2.ZERO
		
	if _right_trigger_action_name != "RT":
		_right_trigger_action_name = "RT"
	_right_trigger_key = Key.KEY_E
	_right_trigger_mouse_button = MouseButton.MOUSE_BUTTON_RIGHT
	_right_trigger_touch_visible = true
	_right_trigger_texture_normal = load("res://addons/input_manager/textures/rt_normal.png")
	_right_trigger_texture_pressed = load("res://addons/input_manager/textures/rt_pressed.png")
	_right_trigger_position = Vector2.ZERO
	
	if _left_shoulder_action_name != "LB":
		_left_shoulder_action_name = "LB"
	_left_shoulder_type = InputManagerConst._event_type_enum.PRESSED
	_left_shoulder_key = KEY_U
	_left_shoulder_touch_visible = true
	_left_shoulder_texture_normal = load("res://addons/input_manager/textures/lb_normal.png")
	_left_shoulder_texture_pressed = load("res://addons/input_manager/textures/lb_pressed.png")
	_left_shoulder_position = Vector2.ZERO
		
	if _right_shoulder_action_name != "RB":
		_right_shoulder_action_name = "RB"
	_right_shoulder_type = InputManagerConst._event_type_enum.PRESSED
	_right_shoulder_key = KEY_O
	_right_shoulder_touch_visible = true
	_right_shoulder_texture_normal = load("res://addons/input_manager/textures/rb_normal.png")
	_right_shoulder_texture_pressed = load("res://addons/input_manager/textures/rb_pressed.png")
	_right_shoulder_position = Vector2.ZERO
	
	if _left_stick_button_action_name != "LSB":
		_left_stick_button_action_name = "LSB"
	_left_stick_button_type = InputManagerConst._event_type_enum.PRESSED
	_left_stick_button_key = KEY_F
	_left_stick_button_touch_visible = true
	_left_stick_button_texture_normal = load("res://addons/input_manager/textures/left_stick_button_normal.png")
	_left_stick_button_texture_pressed = load("res://addons/input_manager/textures/left_stick_button_normal.png")
	_left_stick_button_position = Vector2.ZERO
	
	if _right_stick_button_action_name != "RSB":
		_right_stick_button_action_name = "RSB"
	_right_stick_button_type = InputManagerConst._event_type_enum.PRESSED
	_right_stick_button_key = KEY_G
	_right_stick_button_touch_visible = true
	_right_stick_button_texture_normal = load("res://addons/input_manager/textures/right_stick_button_normal.png")
	_right_stick_button_texture_pressed = load("res://addons/input_manager/textures/right_stick_button_normal.png")
	_right_stick_button_position = Vector2.ZERO
	
	if _button_a_action_name != "A":
		_button_a_action_name = "A"
	_button_a_type = InputManagerConst._event_type_enum.PRESSED
	_button_a_key = KEY_SPACE
	_button_a_touch_visible = true
	_button_a_texture_normal = load("res://addons/input_manager/textures/a_normal.png")
	_button_a_texture_pressed = load("res://addons/input_manager/textures/a_pressed.png")
	_button_a_position = Vector2.ZERO
	
	if _button_b_action_name != "B":
		_button_b_action_name = "B"
	_button_b_type = InputManagerConst._event_type_enum.PRESSED
	_button_b_key = KEY_Z
	_button_b_touch_visible = true
	_button_b_texture_normal = load("res://addons/input_manager/textures/b_normal.png")
	_button_b_texture_pressed = load("res://addons/input_manager/textures/b_pressed.png")
	_button_b_position = Vector2.ZERO

	if _button_x_action_name != "X":
		_button_x_action_name = "X"
	_button_x_type = InputManagerConst._event_type_enum.PRESSED
	_button_x_key = KEY_X
	_button_x_touch_visible = true
	_button_x_texture_normal = load("res://addons/input_manager/textures/x_normal.png")
	_button_x_texture_pressed = load("res://addons/input_manager/textures/x_pressed.png")
	_button_x_position = Vector2.ZERO

	if _button_y_action_name != "Y":
		_button_y_action_name = "Y"
	_button_y_type = InputManagerConst._event_type_enum.PRESSED
	_button_y_key = KEY_C
	_button_y_touch_visible = true
	_button_y_texture_normal = load("res://addons/input_manager/textures/y_normal.png")
	_button_y_texture_pressed = load("res://addons/input_manager/textures/y_pressed.png")
	_button_y_position = Vector2.ZERO

	if _button_dpad_up_action_name != "D_PAD_UP":
		_button_dpad_up_action_name = "D_PAD_UP"
	_button_dpad_up_type = InputManagerConst._event_type_enum.PRESSED
	_button_dpad_up_key = KEY_UP
	_button_dpad_up_touch_visible = true
	_button_dpad_up_texture_normal = load("res://addons/input_manager/textures/d_pad_up_normal.png")
	_button_dpad_up_texture_pressed = load("res://addons/input_manager/textures/d_pad_up_pressed.png")
	_button_dpad_up_position = Vector2.ZERO

	if _button_dpad_down_action_name != "D_PAD_DOWN":
		_button_dpad_down_action_name = "D_PAD_DOWN"
	_button_dpad_down_type = InputManagerConst._event_type_enum.PRESSED
	_button_dpad_down_key = KEY_DOWN
	_button_dpad_down_touch_visible = true
	_button_dpad_down_texture_normal = load("res://addons/input_manager/textures/d_pad_down_normal.png")
	_button_dpad_down_texture_pressed = load("res://addons/input_manager/textures/d_pad_down_pressed.png")
	_button_dpad_down_position = Vector2.ZERO

	if _button_dpad_left_action_name != "D_PAD_LEFT":
		_button_dpad_left_action_name = "D_PAD_LEFT"
	_button_dpad_left_type = InputManagerConst._event_type_enum.PRESSED
	_button_dpad_left_key = KEY_LEFT
	_button_dpad_left_touch_visible = true
	_button_dpad_left_texture_normal = load("res://addons/input_manager/textures/d_pad_left_normal.png")
	_button_dpad_left_texture_pressed = load("res://addons/input_manager/textures/d_pad_left_pressed.png")
	_button_dpad_left_position = Vector2.ZERO

	if _button_dpad_right_action_name != "D_PAD_RIGHT":
		_button_dpad_right_action_name = "D_PAD_RIGHT"
	_button_dpad_right_type = InputManagerConst._event_type_enum.PRESSED
	_button_dpad_right_key = KEY_RIGHT
	_button_dpad_right_touch_visible = true
	_button_dpad_right_texture_normal = load("res://addons/input_manager/textures/d_pad_right_normal.png")
	_button_dpad_right_texture_pressed = load("res://addons/input_manager/textures/d_pad_right_pressed.png")
	_button_dpad_right_position = Vector2.ZERO

	if _button_start_action_name != "START":
		_button_start_action_name = "START"
	_button_start_type = InputManagerConst._event_type_enum.PRESSED
	_button_start_key = KEY_ENTER
	_button_start_touch_visible = true
	_button_start_texture_normal = load("res://addons/input_manager/textures/start_normal.png")
	_button_start_texture_pressed = load("res://addons/input_manager/textures/start_pressed.png")
	_button_start_position = Vector2.ZERO

	if _button_select_action_name != "BACK":
		_button_select_action_name = "BACK"
	_button_select_type = InputManagerConst._event_type_enum.PRESSED
	_button_select_key = KEY_BACKSPACE
	_button_select_touch_visible = true
	_button_select_texture_normal = load("res://addons/input_manager/textures/menu_normal.png")
	_button_select_texture_pressed = load("res://addons/input_manager/textures/menu_normal.png")
	_button_select_position = Vector2.ZERO
	
	_mouse_enable_event_without_captured = false
	_mouse_capture_key = KEY_TAB
	_mouse_visble_key = KEY_ESCAPE
	
	
	pass
