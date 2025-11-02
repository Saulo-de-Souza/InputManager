@tool
extends EditorPlugin

var icon: CompressedTexture2D = preload("res://addons/input_manager/icon-16x16.png")
var main_script: Script = preload("res://addons/input_manager/input_manager.gd")


func _enter_tree() -> void:
	add_custom_type("InputManager", "Node", main_script, icon)


func _exit_tree() -> void:
	remove_custom_type("InputManager")
