extends MirrorSprite2D

@export var player: Player
@export var normal_trident_texture: Texture2D
@export var mirror_trident_texture: Texture2D

func update():
	if player.is_thrown():
		super.update()
	else:
		texture = mirror_trident_texture if GameManager.mirror else normal_trident_texture
