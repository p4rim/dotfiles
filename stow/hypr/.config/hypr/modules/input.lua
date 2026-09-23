hl.config({
	input = {
		kb_layout = "us,ara",
		kb_variant = "",
		kb_model = "",
		kb_options = "caps:hyper,grp:alt_shift_toggle",
		kb_rules = "",
		follow_mouse = 1,
		repeat_rate = 60,
		repeat_delay = 200,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
