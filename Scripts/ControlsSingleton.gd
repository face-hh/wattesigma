extends Node

@onready var gui = $/root/GUI
@onready var blur_overlay = $/root/GUI/BlurOverlay
@onready var tabs_overlay = $/root/GUI/TabsOverlay
@onready var search_bar = $/root/GUI/SearchBar

var non_fading_overlays = []
var active_overlay = null

func _ready():
	# Add any overlays that shouldn't fade to this list
	non_fading_overlays.append(search_bar)

func _process(delta):
	if Input.is_action_just_pressed("tab"):
		toggle_overlay(tabs_overlay)
	if Input.is_action_just_pressed("search"):
		toggle_overlay(search_bar)

func toggle_overlay(new_overlay):
	var tween = create_tween()
	var tween_duration = 0.2

	if new_overlay.visible:
		# Fade out the active overlay
		fade_out(tween, new_overlay, tween_duration)
		if blur_overlay.visible and active_overlay == new_overlay:
			fade_out(tween, blur_overlay, tween_duration)
		active_overlay = null
	else:
		# If another overlay is active, fade it out
		if active_overlay and active_overlay != new_overlay:
			fade_out(tween, active_overlay, tween_duration)
		
		# Fade in the new overlay
		if not blur_overlay.visible:
			fade_in(tween, blur_overlay, tween_duration)
		fade_in(tween, new_overlay, tween_duration)
		
		new_overlay.set_initial_state()
		active_overlay = new_overlay

	tween.play()

func fade_in(tween, node, duration):
	node.visible = true
	if node not in non_fading_overlays:
		node.modulate.a = 0.0
		tween.parallel().tween_property(node, "modulate:a", 1.0, duration)
	else:
		node.modulate.a = 1.0

func fade_out(tween, node, duration):
	if node not in non_fading_overlays:
		tween.parallel().tween_property(node, "modulate:a", 0.0, duration)
	tween.tween_callback(func(): node.visible = false)
