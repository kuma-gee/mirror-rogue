extends HitFlash2D

func _set_hit_flash(mat: ShaderMaterial, enable: bool):
	mat.set_shader_parameter("mirror", GameManager.mirror)
	mat.set_shader_parameter("enabled", enable)
