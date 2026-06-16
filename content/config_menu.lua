Suika = SMODS.current_mod
SuikaLatro.UI = {}

-- code from Suika (Jtem 2) tetris config
function SuikaLatro.IsActionPressed(action)
	local a = Suika.config.suikalatro_controls[action]
	if not a then return false end
	return love.keyboard.isScancodeDown(a)
end

SuikaLatro.UI = {}
function SuikaLatro.UI.LocalizeKeybind(key)
	if not key then
		key = "None"
	end
	-- Backwards compatibility
	if key == "[" then
		key = "Left Bracket"
	elseif key == "]" then
		key = "Right Bracket"
	end
	local result = (G.localization.misc.keybinds or {})[key] or key
	return result
end

function SuikaLatro.UI.UpdateBindButtonText(text)
	if not SuikaLatro.UI.bind_button then return end
	local button_text = SuikaLatro.UI.bind_button.children[1].children[1]
	button_text.config.text_drawable = nil
	button_text.config.text = text
	button_text:update_text()
	button_text.UIBox:recalculate()
end

function SuikaLatro.UI.InitBind(button)
	if SuikaLatro.UI.bind_button then SuikaLatro.UI.CancelBind() end
	button.config.button = nil
	SuikaLatro.UI.bind_button = button
	SuikaLatro.UI.bind_key = button.config.ref_table.bind
	SuikaLatro.UI.bind_real = button.config.ref_table.key
	SuikaLatro.UI.UpdateBindButtonText("[ " .. "WAITING" .. " ]")
end

local old_keypressed = love.keypressed
function love.keypressed(key, scancode, isrepeat)
	if old_keypressed then
		old_keypressed(key, scancode, isrepeat)
	end
	if not SuikaLatro.UI.bind_button then return end
	SuikaLatro.UI.CompleteBind(scancode)
	SMODS.save_mod_config(Suika)
end

local non_safe_keys_table = {
	["Left Mouse"] = true,
	["Right Mouse"] = true,
	["(Left)"] = true,
	["(Right)"] = true,
	["(Up)"] = true,
	["(Down)"] = true,
	["(X)"] = true,
	["(Y)"] = true,
	["(A)"] = true,
	["(B)"] = true,
}

function SuikaLatro.UI.CompleteBind(key)
	if key == "escape" then return SuikaLatro.UI.CancelBind() end
	if non_safe_keys_table[key] then return SuikaLatro.UI.CancelBind() end

	Suika.config.controls[SuikaLatro.UI.bind_key] = key
	SuikaLatro.UI.UpdateBindButtonText(SuikaLatro.UI.LocalizeKeybind(key) or "None")
	if SuikaLatro.UI.bind_button then
		SuikaLatro.UI.bind_button.config.button = "suikalatro_start_bind"
		SuikaLatro.UI.bind_button.config.ref_table.key = key
	end
	SuikaLatro.UI.bind_button = nil
	SuikaLatro.UI.bind_key = nil
end

function SuikaLatro.UI.CancelBind()
	if not SuikaLatro.UI.bind_button then return end
	SuikaLatro.UI.UpdateBindButtonText(SuikaLatro.UI.LocalizeKeybind(SuikaLatro.UI.bind_real) or "None")
	if SuikaLatro.UI.bind_button then
		SuikaLatro.UI.bind_button.config.button = "suikalatro_start_bind"
	end
	SuikaLatro.UI.bind_button = nil
	SuikaLatro.UI.bind_key = nil
end

local old_eom = G.FUNCS.exit_overlay_menu
function G.FUNCS.exit_overlay_menu(...)
	SuikaLatro.UI.CancelBind()
	return old_eom(...)
end

function G.FUNCS.suikalatro_start_bind(e)
	SuikaLatro.UI.InitBind(e)
end

function SuikaLatro.UI.CreateKeybindUI(key, bind)
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.01,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { align = "c", minw = 4, maxw = 4 },
				nodes = {
					{
						n = G.UIT.T,
						config = {
							text = key,
							colour = G.C.WHITE,
							scale = 0.3
						}
					}
				}
			},
			{
				n = G.UIT.C,
				config = { align = "cm", minw = 0.75 }
			},
			UIBox_button({
				label = { SuikaLatro.UI.LocalizeKeybind(Suika.config.controls[bind]) or "None" },
				col = true,
				colour = G.C.GREEN,
				scale = 0.3,
				minw = 2.75,
				maxw = 2.75,
				minh = 0.4,
				maxh = 0.4,
				ref_table = {
					key = Suika.config.controls[bind],
					bind = bind,
				},
				focus_args = { nav = "wide" },
				button = "suikalatro_start_bind"
			})
		}
	}
end

function SuikaLatro.UI.CreateSection(text)
	return {
		n = G.UIT.R,
		config = { align = "cm", padding = 0.075 },
		nodes = {
			{
				n = G.UIT.T,
				config = {
					text = text,
					colour = G.C.WHITE,
					scale = 0.35,
					align = "cm",
				},
			},
		},
	}
end

Suika.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = "m", r = 0.1, padding = 0.05, colour = G.C.BLACK, minw = 8, minh = 6 },
		nodes = {
			{ n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },

			{
				n = G.UIT.C,
				config = { align = "cm", padding = 0.05 },
				nodes = {
                    
					-- Keybinds
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							padding = 0
						},
						nodes = {
							{
								n = G.UIT.C,
								config = { align = 'cm', padding = 0.05 },
								nodes = {
									SuikaLatro.UI.CreateKeybindUI("Move cursor left", "cursor_left"),
									SuikaLatro.UI.CreateKeybindUI("Move cursor right", "cursor_right"),
									SuikaLatro.UI.CreateKeybindUI("Drop ball", "drop"),
                                    SuikaLatro.UI.CreateKeybindUI("Move cursor left (alt)", "cursor_left_alt"),
                                    SuikaLatro.UI.CreateKeybindUI("Move cursor right (alt)", "cursor_right_alt"),
                                    SuikaLatro.UI.CreateKeybindUI("Drop ball (alt)", "drop_alt"),
								}
							}
						},
					},
				}
			},

			{ n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },

		}
	}
end