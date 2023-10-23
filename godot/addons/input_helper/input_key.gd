# Maps inputs to image from https://thoseawesomeguys.com/prompts/
class_name InputKey
extends Node

const ASSETS_FOLDER = "res://assets/Inputs/"
const JOYPAD_KEYS = {
	InputHelper.DEVICE_PLAYSTATION_CONTROLLER: preload("res://addons/input_helper/joypad/ps5_keys.tres"),
	InputHelper.DEVICE_XBOX_CONTROLLER: preload("res://addons/input_helper/joypad/xbox_keys.tres"),
	InputHelper.DEVICE_GENERIC: preload("res://addons/input_helper/joypad/deck_keys.tres"),
}

const KEY_MAPS = {
	"Left": "Arrow_Left",
	"Right": "Arrow_Right",
	"Up": "Arrow_Up",
	"Down": "Arrow_Down",
	# TODO: probably will be more
}

@export var action := ""
@export_enum("Light", "Dark") var theme := "Dark" # For keyboard/mouse

@onready var node = get_parent()

func _ready():
	update()
	
func update():
	if node is Sprite2D or node is TextureRect:
		node.texture = get_texture()

func get_texture() -> Texture2D:
	var dev = InputHelper.device
	var ev = InputHelper.get_keyboard_input_for_action(action)
	var type = InputType.to_type(ev)
	
	if dev == InputHelper.DEVICE_KEYBOARD:
		var text = InputType.to_text(type)
		var folder = ASSETS_FOLDER + "Keyboard & Mouse"
		var file = "%s/%s/%s_Key_%s.png" % [folder, theme, text, theme]
		return load(file)
	
	if dev in JOYPAD_KEYS:
		var keys: JoypadKeys = JOYPAD_KEYS[dev]
		return keys.get_texture(type)
	
	return load("res://assets/Inputs/Keyboard & Mouse/Blanks/Blank_Black_Enter.png")
