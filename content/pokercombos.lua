function CardArea:parse_highlighted()

end

function SMODS.current_mod.reset_game_globals(run_start) --hide vanilla poker hands
    if run_start then 
        for k,v in pairs(G.GAME.hands) do 
            if not string.find(k, 'suika') then
                SMODS.PokerHand:take_ownership(k,
                    {
                    visible = function(self) return false end
                    },
                    true
                )
            end
        end
    end
end

SMODS.PokerHand { -- Mega Flush
    key = 'mega_flush',
    loc_txt = {
        name = "Mega Flush",
        description = {
            "A contiguous group of 15+ balls",
            "of the same suit touching",
        }
    },
    mult = SuikaLatro.poker_combos.mega_flush.mult,
    chips = SuikaLatro.poker_combos.mega_flush.chips,
    l_mult = SuikaLatro.poker_combos.mega_flush.mult_mod,
    l_chips = SuikaLatro.poker_combos.mega_flush.chips_mod,
    example = {},
    order_offset = 10000,
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('neptune',
    {
    config = { hand_type = 'suika_mega_flush' }
    },
    true
)

SMODS.PokerHand { -- 10-Flush
    key = 'ten_flush',
    loc_txt = {
        name = "10-Flush",
        description = {
            "A contiguous group of 10-14 balls",
            "of the same suit touching",
        }
    },
    mult = SuikaLatro.poker_combos.ten_flush.mult,
    chips = SuikaLatro.poker_combos.ten_flush.chips,
    l_mult = SuikaLatro.poker_combos.ten_flush.mult_mod,
    l_chips = SuikaLatro.poker_combos.ten_flush.chips_mod,
    example = {},
    order_offset = 10000,
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('earth',
    {
    config = { hand_type = 'suika_ten_flush' }
    },
    true
)

SMODS.PokerHand { -- 5-Flush
    key = 'five_flush',
    loc_txt = {
        name = "5-Flush",
        description = {
            "A contiguous group of 5-9 balls",
            "of the same suit touching",
        }
    },
    mult = SuikaLatro.poker_combos.five_flush.mult,
    chips = SuikaLatro.poker_combos.five_flush.chips,
    l_mult = SuikaLatro.poker_combos.five_flush.mult_mod,
    l_chips = SuikaLatro.poker_combos.five_flush.chips_mod,
    example = {},
    order_offset = 10000,
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('jupiter',
    {
    config = { hand_type = 'suika_five_flush' }
    },
    true
)

SMODS.PokerHand { -- Combo Breaker
    key = 'combo_breaker',
    loc_txt = {
        name = "Combo Breaker",
        description = {
            "If a ball merged for the",
            "5th+ time during the hand",
        }
    },
    mult = SuikaLatro.poker_combos.combo_breaker.mult,
    chips = SuikaLatro.poker_combos.combo_breaker.chips,
    l_mult = SuikaLatro.poker_combos.combo_breaker.mult_mod,
    l_chips = SuikaLatro.poker_combos.combo_breaker.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('saturn',
    {
    config = { hand_type = 'suika_combo_breaker' }
    },
    true
)

SMODS.PokerHand { -- Merge 4X
    key = 'merge_4',
    loc_txt = {
        name = "Merge 4X",
        description = {
            "If a ball merged for the",
            "4th time during the hand",
        }
    },
    mult = SuikaLatro.poker_combos.merge_4.mult,
    chips = SuikaLatro.poker_combos.merge_4.chips,
    l_mult = SuikaLatro.poker_combos.merge_4.mult_mod,
    l_chips = SuikaLatro.poker_combos.merge_4.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('mars',
    {
    config = { hand_type = 'suika_merge_4' }
    },
    true
)

SMODS.PokerHand { -- Merge 3X
    key = 'merge_3',
    loc_txt = {
        name = "Merge 3X",
        description = {
            "If a ball merged for the",
            "3rd time during the hand",
        }
    },
    mult = SuikaLatro.poker_combos.merge_3.mult,
    chips = SuikaLatro.poker_combos.merge_3.chips,
    l_mult = SuikaLatro.poker_combos.merge_3.mult_mod,
    l_chips = SuikaLatro.poker_combos.merge_3.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('venus',
    {
    config = { hand_type = 'suika_merge_3' }
    },
    true
)

SMODS.PokerHand { -- Merge 2X
    key = 'merge_2',
    loc_txt = {
        name = "Merge 2X",
        description = {
            "If a ball merged for the",
            "2nd time during the hand",
        }
    },
    mult = SuikaLatro.poker_combos.merge_2.mult,
    chips = SuikaLatro.poker_combos.merge_2.chips,
    l_mult = SuikaLatro.poker_combos.merge_2.mult_mod,
    l_chips = SuikaLatro.poker_combos.merge_2.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('uranus',
    {
    config = { hand_type = 'suika_merge_2' }
    },
    true
)

SMODS.PokerHand { -- Merge 1X
    key = 'merge_1',
    loc_txt = {
        name = "Merge 1X",
        description = {
            "If balls merged for the",
            "1st time during the hand",
        }
    },
    mult = SuikaLatro.poker_combos.merge_1.mult,
    chips = SuikaLatro.poker_combos.merge_1.chips,
    l_mult = SuikaLatro.poker_combos.merge_1.mult_mod,
    l_chips = SuikaLatro.poker_combos.merge_1.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('mercury',
    {
    config = { hand_type = 'suika_merge_1' }
    },
    true
)

SMODS.PokerHand { -- Lowball
    key = 'lowball',
    loc_txt = {
        name = "Lowball",
        description = {
            "If none of the above",
            "poker combo types occur",
        }
    },
    mult = SuikaLatro.poker_combos.lowball.mult,
    chips = SuikaLatro.poker_combos.lowball.chips,
    l_mult = SuikaLatro.poker_combos.lowball.mult_mod,
    l_chips = SuikaLatro.poker_combos.lowball.chips_mod,
    example = {},
    evaluate = function(parts, hand)
    
    end
}

SMODS.Consumable:take_ownership('pluto',
    {
    config = { hand_type = 'suika_lowball' }
    },
    true
)

SMODS.Consumable:take_ownership('ceres',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Consumable:take_ownership('planet_x',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Consumable:take_ownership('eris',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)