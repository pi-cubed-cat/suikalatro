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
