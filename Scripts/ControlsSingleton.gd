extends Node

@onready var gui = $/root/GUI
@onready var blur_overlay = $/root/GUI/BlurOverlay
@onready var tabs_overlay = $/root/GUI/TabsOverlay

func _process(delta):
	if Input.is_action_just_pressed("tab"):
		toggle_overlay(tabs_overlay, blur_overlay)

func toggle_overlay(new_overlay, background_overlay):
	var tween = create_tween()
	var tween_duration = 0.2

	if new_overlay.visible:
		# Fade out both overlays
		fade_out(tween, new_overlay, tween_duration)
		fade_out(tween, background_overlay, tween_duration)
	else:
		# Fade in both overlays
		fade_in(tween, background_overlay, tween_duration)
		fade_in(tween, new_overlay, tween_duration)
		
		new_overlay.set_initial_state()

	tween.play()

func fade_in(tween, node, duration):
	node.visible = true
	node.modulate.a = 0.0
	tween.parallel().tween_property(node, "modulate:a", 1.0, duration)

func fade_out(tween, node, duration):
	tween.parallel().tween_property(node, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): node.visible = false)
