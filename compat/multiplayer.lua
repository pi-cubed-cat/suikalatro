--[[SMODS.Joker:take_ownership('mp_hanging_chad',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)]]

action_asteroid = function()
    local hand_priority = {
        ['suika_five_flush'] = 5,
        ['suika_ten_flush'] = 3,
        ['suika_mega_flush'] = 1,
        ['suika_merge_1'] = 8,
        ['suika_merge_2'] = 7,
        ['suika_merge_3'] = 6,
        ['suika_merge_4'] = 4,
        ['suika_combo_breaker'] = 2,
        ['suika_lowball'] = 9,
    }
    local hand_type = 'suika_lowball'
    local max_level = 0

    for k, v in pairs(G.GAME.hands) do
        if SMODS.is_poker_hand_visible(k) then
            if
                to_big(v.level) > to_big(max_level)
                or (to_big(v.level) == to_big(max_level) and hand_priority[k] < hand_priority[hand_type])
            then
                hand_type = k
                max_level = v.level
            end
        end
    end
    update_hand_text({ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 }, {
        handname = localize(hand_type, "poker_hands"),
        chips = G.GAME.hands[hand_type].chips,
        mult = G.GAME.hands[hand_type].mult,
        level = G.GAME.hands[hand_type].level,
    })
    level_up_hand(nil, hand_type, false, -1)
    update_hand_text(
        { sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
        { mult = 0, chips = 0, handname = "", level = "" }
    )
end

SuikaLatro.MP_funcs = {}

function SuikaLatro.MP_funcs.action_end_pvp()
	MP.GAME.end_pvp = true
	MP.GAME.timer = MP.LOBBY.config.timer_base_seconds
	MP.GAME.timer_started = false
end

function SuikaLatro.MP_funcs.eval_hand_and_jokers()
	for i = 1, #G.hand.cards do
		--Check for hand doubling
		local reps = { 1 }
		local j = 1
		while j <= #reps do
			local percent = (i - 0.999) / (#G.hand.cards - 0.998) + (j - 1) * 0.1
			if reps[j] ~= 1 then
				card_eval_status_text(
					(reps[j].jokers or reps[j].seals).card,
					"jokers",
					nil,
					nil,
					nil,
					(reps[j].jokers or reps[j].seals)
				)
			end

			--calculate the hand effects
			local effects = { G.hand.cards[i]:get_end_of_round_effect() }
			for k = 1, #G.jokers.cards do
				--calculate the joker individual card effects
				local eval = G.jokers.cards[k]:calculate_joker({
					cardarea = G.hand,
					other_card = G.hand.cards[i],
					individual = true,
					end_of_round = true,
				})
				if eval then table.insert(effects, eval) end
			end

			if reps[j] == 1 then
				--Check for hand doubling
				--From Red seal
				local eval = eval_card(
					G.hand.cards[i],
					{ end_of_round = true, cardarea = G.hand, repetition = true, repetition_only = true }
				)
				if next(eval) and (next(effects[1]) or #effects > 1) then
					for h = 1, eval.seals.repetitions do
						reps[#reps + 1] = eval
					end
				end

				--from Jokers
				for j = 1, #G.jokers.cards do
					--calculate the joker effects
					local eval = eval_card(G.jokers.cards[j], {
						cardarea = G.hand,
						other_card = G.hand.cards[i],
						repetition = true,
						end_of_round = true,
						card_effects = effects,
					})
					if next(eval) then
						for h = 1, eval.jokers.repetitions do
							reps[#reps + 1] = eval
						end
					end
				end
			end

			for ii = 1, #effects do
				--if this effect came from a joker
				if effects[ii].card then
					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						func = function()
							effects[ii].card:juice_up(0.7)
							return true
						end,
					}))
				end

				--If dollars
				if effects[ii].h_dollars then
					ease_dollars(effects[ii].h_dollars)
					card_eval_status_text(G.hand.cards[i], "dollars", effects[ii].h_dollars, percent)
				end

				--Any extras
				if effects[ii].extra then
					card_eval_status_text(G.hand.cards[i], "extra", nil, percent, nil, effects[ii].extra)
				end
			end
			j = j + 1
		end
	end
end