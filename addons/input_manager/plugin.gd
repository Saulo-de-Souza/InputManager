@tool
extends EditorPlugin

var icon: CompressedTexture2D = preload("res://addons/input_manager/icon.svg")
var main_script: Script = preload("res://addons/input_manager/input_manager.gd")
var input_manager_data_script: Script = preload("res://addons/input_manager/input_manager_data.gd")
var input_manager_const_script: Script = preload("res://addons/input_manager/const.gd")


func _enter_tree() -> void:
	add_custom_type("InputManager", "Node", main_script, icon)
	add_custom_type("InputManagerData", "Resource", input_manager_data_script, icon)
	add_custom_type("InputManagerConst", "Resource", input_manager_const_script, icon)


func _exit_tree() -> void:
	remove_custom_type("InputManager")
	remove_custom_type("InputManagerData")
	remove_custom_type("InputManagerConst")
