class_name JoypadKeys
extends Resource

@export var JOYSTICK_L_UP: Texture2D
@export var JOYSTICK_L_DOWN: Texture2D
@export var JOYSTICK_L_RIGHT: Texture2D
@export var JOYSTICK_L_LEFT: Texture2D
@export var JOYSTICK_L_CLICK: Texture2D

@export var JOYSTICK_R_UP: Texture2D
@export var JOYSTICK_R_DOWN: Texture2D
@export var JOYSTICK_R_RIGHT: Texture2D
@export var JOYSTICK_R_LEFT: Texture2D
@export var JOYSTICK_R_CLICK: Texture2D

@export var JOYSTICK_DPAD_UP: Texture2D
@export var JOYSTICK_DPAD_DOWN: Texture2D
@export var JOYSTICK_DPAD_LEFT: Texture2D
@export var JOYSTICK_DPAD_RIGHT: Texture2D

@export var JOYSTICK_A: Texture2D
@export var JOYSTICK_B: Texture2D
@export var JOYSTICK_X: Texture2D
@export var JOYSTICK_Y: Texture2D

@export var JOYSTICK_L1: Texture2D
@export var JOYSTICK_L2: Texture2D
@export var JOYSTICK_R1: Texture2D
@export var JOYSTICK_R2: Texture2D

@export var JOYSTICK_START: Texture2D
@export var JOYSTICK_HOME: Texture2D
@export var JOYSTICK_SELECT: Texture2D

func get_texture(type: InputType.Key) -> Texture2D:
	match type:
		JOYSTICK_L_UP: return JOYSTICK_L_UP
		JOYSTICK_L_DOWN: return JOYSTICK_L_DOWN
		JOYSTICK_L_RIGHT: return JOYSTICK_L_RIGHT
		JOYSTICK_L_LEFT: return JOYSTICK_L_LEFT
		
		JOYSTICK_R2: return JOYSTICK_R2
		JOYSTICK_L2: return JOYSTICK_L2
		
		JOYSTICK_R_UP: return JOYSTICK_R_UP
		JOYSTICK_R_DOWN: return JOYSTICK_R_DOWN
		JOYSTICK_R_RIGHT: return JOYSTICK_R_RIGHT
		JOYSTICK_R_LEFT: return JOYSTICK_R_LEFT
		
		JOYSTICK_START: return JOYSTICK_START
		JOYSTICK_R1: return JOYSTICK_R1
		JOYSTICK_L1: return JOYSTICK_L1
		JOYSTICK_A: return JOYSTICK_A
		JOYSTICK_B: return JOYSTICK_B
		JOYSTICK_X: return JOYSTICK_X
		JOYSTICK_Y: return JOYSTICK_Y
		JOYSTICK_DPAD_UP: return JOYSTICK_DPAD_UP
		JOYSTICK_DPAD_DOWN: return JOYSTICK_DPAD_DOWN
		JOYSTICK_DPAD_LEFT: return JOYSTICK_DPAD_LEFT
		JOYSTICK_DPAD_RIGHT: return JOYSTICK_DPAD_RIGHT
		JOYSTICK_L_CLICK: return JOYSTICK_L_CLICK
		JOYSTICK_R_CLICK: return JOYSTICK_R_CLICK
		JOYSTICK_HOME: return JOYSTICK_HOME
		JOYSTICK_SELECT: return JOYSTICK_SELECT
		
	return JOYSTICK_HOME
