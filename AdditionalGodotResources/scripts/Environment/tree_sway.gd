extends Node2D

@export var wind_strength : float

func _ready() -> void:
	wind_strength = self.get_child(0).material.shader_parameter.WindStrength
