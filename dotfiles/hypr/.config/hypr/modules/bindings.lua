local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "dolphin"
local browser = "chromium"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.kill({}))
hl.bind(
	mainMod .. " + M",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("qs ipc call launcher toggle"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

local function sendCombo(mods, key)
	return function()
		hl.dispatch(hl.dsp.send_key_state({
			mods = mods,
			key = key,
			state = "down",
			window = "activewindow",
		}))

		hl.timer(function()
			hl.dispatch(hl.dsp.send_key_state({
				mods = mods,
				key = key,
				state = "up",
				window = "activewindow",
			}))
		end, { timeout = 25, type = "oneshot" })
	end
end

hl.bind("SUPER + C", sendCombo("CTRL", "Insert"))
hl.bind("SUPER + V", sendCombo("SHIFT", "Insert"))
hl.bind("SUPER + X", sendCombo("CTRL", "X"))
hl.bind("SUPER + A", sendCombo("CTRL", "A"))
hl.bind("SUPER + Z", sendCombo("CTRL", "Z"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

hl.bind("SUPER + minus", hl.dsp.window.resize({ x = 100, y = 0, relative = true }), { repeating = true })
hl.bind("SUPER + equal", hl.dsp.window.resize({ x = -100, y = 0, relative = true }), { repeating = true })

local capsChordUsed = false

local function switchWorkspace(delta)
	capsChordUsed = true
	local current = hl.get_active_workspace()
	if current == nil then
		return
	end

	local workspaces = {}
	for _, workspace in ipairs(hl.get_workspaces()) do
		if workspace.id > 0 then
			table.insert(workspaces, workspace)
		end
	end

	table.sort(workspaces, function(a, b)
		return a.id < b.id
	end)

	local currentIndex = nil
	for index, workspace in ipairs(workspaces) do
		if workspace.id == current.id then
			currentIndex = index
			break
		end
	end

	if currentIndex == nil then
		return
	end

	local target = workspaces[currentIndex + delta]
	if target ~= nil then
		hl.dispatch(hl.dsp.focus({ workspace = target.id }))
	end
end

hl.bind("MOD3 + Hyper_L", function()
	capsChordUsed = false
end)
hl.bind("MOD3 + H", function()
	switchWorkspace(-1)
end)
hl.bind("MOD3 + L", function()
	switchWorkspace(1)
end)
hl.bind("MOD3 + Hyper_L", function()
	if not capsChordUsed then
		hl.dispatch(hl.dsp.window.cycle_next())
		hl.dispatch(hl.dsp.window.bring_to_top())
	end
end, { release = true, description = "Tap Caps to focus next window" })

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
