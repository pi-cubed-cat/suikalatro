-- new blind scaling
function get_blind_amount(ante)
if G.GAME.modifiers.scaling and (G.GAME.modifiers.scaling ~= 1 and G.GAME.modifiers.scaling ~= 2 and G.GAME.modifiers.scaling ~= 3) then return SMODS.get_blind_amount(ante) end
  local k = 0.75
  if not G.GAME.modifiers.scaling or G.GAME.modifiers.scaling == 1 then 
    local amounts = {
      300,  800, 2000,  5000,  11000,  20000,   35000,  50000
    }
    if ante < 1 then return 100 end
    if ante <= 8 then return amounts[ante] end
    local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
    local amount = math.floor(a*(b+(k*c)^d)^c)
    amount = amount - amount%(10^math.floor(math.log10(amount)-1))
    return amount
  elseif G.GAME.modifiers.scaling == 2 then 
    local amounts = {
      400,  1000, 3200,  9000,  25000,  60000,  110000,  200000
      --300,  900, 2400,  7000,  18000,  32000,  56000,  90000
    }
    if ante < 1 then return 100 end
    if ante <= 8 then return amounts[ante] end
    local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
    local amount = math.floor(a*(b+(k*c)^d)^c)
    amount = amount - amount%(10^math.floor(math.log10(amount)-1))
    return amount
  elseif G.GAME.modifiers.scaling == 3 then 
    local amounts = {
      500,  2000, 5000,  15000,  50000,  200000,  400000,  800000
      --300,  1000, 3000,  8000,  22000,  50000,  90000,  180000
    }
    if ante < 1 then return 100 end
    if ante <= 8 then return amounts[ante] end
    local a, b, c, d = amounts[8],1.6,ante-8, 1 + 0.2*(ante-8)
    local amount = math.floor(a*(b+(k*c)^d)^c)
    amount = amount - amount%(10^math.floor(math.log10(amount)-1))
    return amount
  end
end

-- 10X blind ante
local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)
    return get_blind_amount_ref(ante) * 10
end

SMODS.Blind:take_ownership('arm',
    {
        name = "The Arm 2",
        boss = { min = 2 },
        calculate = function(self, blind, context)
            if blind.disabled then return end

            if context.after and G.GAME.hands[G.GAME.last_scoring_combo] then
                if G.GAME.hands[G.GAME.last_scoring_combo].level > 1 then
                    blind.triggered = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:wiggle()
                            level_up_hand(card, G.GAME.last_scoring_combo, nil, -1)
                            return true
                        end
                    }))
                end
            end
        end
            
    },
    false
)

SMODS.Blind:take_ownership('house',
    {
    },
    false
)

SMODS.Blind:take_ownership('ox',
    {
        name = "The Ox 2",
        loc_vars = function(self)
        return { vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
        end,
        collection_loc_vars = function(self)
            return { vars = { localize('ph_most_played') } }
        end,
        calculate = function(self, blind, context)
            if blind.disabled then return end

            if context.after and G.GAME.hands[G.GAME.last_scoring_combo] then
                blind.triggered = false
                if G.GAME.hands[G.GAME.last_scoring_combo].key == G.GAME.current_round.most_played_poker_hand then
                    blind.triggered = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.blind:wiggle()
                            ease_dollars(-G.GAME.dollars)
                            return true
                        end
                    }))
                end
            end
        end
    },
    false
)

SMODS.Blind:take_ownership('psychic',
    {
        name = "The Psychic 2",
        debuff = { h_size_ge = nil },
    },
    false
)


SMODS.Blind:take_ownership('eye',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

SMODS.Blind:take_ownership('mouth',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

--[[SMODS.Blind:take_ownership('club',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

SMODS.Blind:take_ownership('goad',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

SMODS.Blind:take_ownership('window',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

SMODS.Blind:take_ownership('head',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)

SMODS.Blind:take_ownership('final_leaf',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    false
)]]

SMODS.Blind:take_ownership('pillar',
    {
    boss = { min = 2 },
    },
    false
)

SMODS.Blind:take_ownership('serpent', 
    {
        name = "The Serpent 2",
        boss = { min = 2 },
        modifies_draw = true, -- SMODS addition, you need this if the blind modifies the draws
        calculate = function(self, blind, context)
            if blind.disabled then return end

            if context.drawing_cards and (G.GAME.current_round.hands_played ~= 0 or G.GAME.current_round.discards_used ~= 0) then
                return {
                    cards_to_draw = 1
                }
            end
        end
    },
    false
)


SMODS.Blind:take_ownership('tooth',
    {
        loc_vars = function(self)
            local numerator, denominator = SMODS.get_probability_vars(self, 1, 3, 'tooth')
            return { vars = { numerator, denominator } }
        end,
        collection_loc_vars = function(self)
            return { vars = { '1', '3' } }
        end,
        calculate = function(self, blind, context)
            if blind.disabled then return end

            if context.suika_drop_card and
            SMODS.pseudorandom_probability(blind, 'tooth', 1, 3) then
                ease_dollars(-1)
                G.GAME.blind:wiggle()
            end
        end
    },
    false
)

SMODS.Blind:take_ownership('fish',
    {
        calculate = function(self, blind, context)
            if context.blind_disabled then
                for i = 1, #G.hand.cards do
                    if G.hand.cards[i].facing == 'back' then
                        G.hand.cards[i]:flip()
                    end
                end
                for _, playing_card in pairs(G.playing_cards) do
                    playing_card.ability.wheel_flipped = nil
                end
            end

            if context.setting_blind or context.hand_drawn or context.press_play then
                blind.prepped = nil
            end

            if blind.disabled then return end

            if context.suika_drop_card then
                blind.prepped = true
            end
            if context.stay_flipped and context.to_area == G.hand and blind.prepped then
                return {
                    stay_flipped = true
                }
            end
        end
    },
    false
)

SMODS.Blind:take_ownership('flint',
    {
        name = "The Flint 2",
        calculate = function(self, blind, context)
            if blind.disabled then return end
        end
    },
    false
)

function SuikaLatro.is_flint_active()
    if G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind.key == 'bl_flint'
    and not G.GAME.blind.disabled then
        G.GAME.blind:juice_up()
        play_sound('cancel', 1, 0.5)
        play_sound('highlight1', 1, 0.1)
        return 0.5
    else 
        return 1
    end
end

SMODS.Blind:take_ownership('plant',
    {
        debuff = {},
        recalc_debuff = function(self, card, from_blind)
            if not SMODS.has_no_rank(card) 
            and (card:get_id() == 2 or card:get_id() == 3 or card:get_id() == 4) then
                return true
            else
                return false
            end
        end
    },
    false
)

SMODS.Blind:take_ownership('final_bell',
    {
        calculate = function(self, blind, context)
            if context.blind_disabled or context.blind_defeated then
                for _, playing_card in ipairs(G.playing_cards) do
                    playing_card.ability.forced_selection = nil
                end
            end

            if blind.disabled then return end

            if context.hand_drawn then
                local any_forced = nil
                if #G.hand.cards > 0 then
                    for _, playing_card in ipairs(G.hand.cards) do
                        if playing_card.ability.forced_selection then
                            any_forced = true
                        end
                    end
                end
                if not any_forced then
                    G.hand:unhighlight_all()
                    local forced_card = pseudorandom_element(G.hand.cards, 'cerulean_bell')
                    forced_card.ability.forced_selection = true
                    G.hand:add_to_highlighted(forced_card)
                end
            end
        end
    },
    false
)

SMODS.Blind:take_ownership('mark',
    {
    boss = { min = 6 },
    },
    false
)

SMODS.Atlas({
    key = 'suikablind',
    path = 'blinds.png',
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
})

SMODS.Blind {
    key = "melon",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 0 },
    atlas = 'suikablind',
    boss = { min = 1 },
    boss_colour = HEX("50bf7c"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.setting_blind then
            SuikaLatro.ball_sizefactor = 15
        end
    end,
    disable = function(self)
        SuikaLatro.ball_sizefactor = 12
    end,
    defeat = function(self)
        SuikaLatro.ball_sizefactor = 12
    end
}

local blind_disable_disable = Blind.disable
function Blind:disable()
	blind_disable_disable(self)
	for k,v in ipairs(SuikaLatro.balls) do
        v.debuff = false
        if v.enhancement == 'm_steel' then
            v.fixture:setDensity(100)
            v.body:resetMassData()
            v.fixture:setUserData(self)
        end
    end
end

SMODS.Blind {
    key = "persimmon",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 2 },
    atlas = 'suikablind',
    boss = { min = 1 },
    boss_colour = HEX("e56a2f"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.after and not blind.disabled then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    G.GAME.blind:wiggle()
                    table.insert(SuikaLatro.balls, Ball(pseudorandom('persimmon')*10, -400, {id = 6}))
                    return true
                end,
            }))
        end
    end,
}

SMODS.Blind {
    key = "cherry",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 1 },
    atlas = 'suikablind',
    boss = { min = 1 },
    boss_colour = HEX("b52d2d"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.setting_blind then
            SuikaLatro.bounciness = 0.75
        end
    end,
    disable = function(self)
        SuikaLatro.bounciness = 0.1
        for k,v in ipairs(SuikaLatro.balls) do
            v.fixture:setRestitution(SuikaLatro.bounciness)
        end
    end,
    defeat = function(self)
        SuikaLatro.bounciness = 0.1
        for k,v in ipairs(SuikaLatro.balls) do
            v.fixture:setRestitution(SuikaLatro.bounciness)
        end
    end
}

SMODS.Blind {
    key = "grape",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 3 },
    atlas = 'suikablind',
    boss = { min = 2 },
    boss_colour = HEX("8a59a5"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.after and not blind.disabled then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    G.GAME.blind:wiggle()
                    for i=1,#SuikaLatro.balls do 
                        local v = SuikaLatro.balls[i]
                        local perma_bonus_table = {}
                        if v.perma_bonuses then
                            for k,v in pairs(v.perma_bonuses) do
                                perma_bonus_table[k] = v
                            end
                        end 
                        table.insert(SuikaLatro.balls, Ball(v.body:getX(), v.body:getY(), v, 1, nil, v.enhancement, v.edition, v.seal, nil, perma_bonus_table, (v.debuff and true) or false))
                        v.remove = true
                    end
                    return true
                end,
            }))
        end
    end
}

SMODS.Blind {
    key = "pear",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 4 },
    atlas = 'suikablind',
    boss = { min = 4 },
    boss_colour = HEX("edb960"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.after and not blind.disabled then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    G.GAME.blind:wiggle()
                    for i=1,#SuikaLatro.balls do 
                        local v = SuikaLatro.balls[i]
                        if v.body:getY() + v.size - SuikaLatro.walls.ground.body:getY() >= -15 then
                            v.remove = true
                            SMODS.calculate_context({balls_shattered = true, other_balls = {v}})
                        end
                    end
                    return true
                end,
            }))
        end
    end,
}

SMODS.Blind {
    key = "peach",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 5 },
    atlas = 'suikablind',
    boss = { min = 1 },
    boss_colour = HEX("cd6d7d"),
    discovered = true, 
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.pre_discard then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    G.GAME.blind:wiggle()
                    for k,v in pairs(SuikaLatro.balls) do
                        v.body:setX(10*(math.random()-0.5))
                        v.body:setY(10*(math.random()-0.5))
                    end
                    return true
                end,
            }))
        end
    end
}

SMODS.Blind {
    key = "dekopon",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 6 },
    atlas = 'suikablind',
    boss = { min = 2 },
    boss_colour = HEX("dea753"),
    discovered = true,
    config = { extra = { balls_remaining = 8 }},
    loc_vars = function(self)
        return { vars = { self.config.extra.balls_remaining } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '8' } }
    end,
    calculate = function(self, blind, context)
        if context.blind_disabled then
            G.GAME.suika_hide_box = nil
        end
        
        if blind.disabled then return end

        if context.setting_blind then
            G.GAME.suika_hide_box = true
            self.config.extra.balls_remaining = 8
        end

        if context.suika_drop_card then
            self.config.extra.balls_remaining = self.config.extra.balls_remaining - 1
            if self.config.extra.balls_remaining <= 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        blind:disable()
                        G.GAME.suika_hide_box = nil
                        return true
                    end
                }))
            end
        end
    end,
}

SMODS.Blind {
    key = "apple",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 7 },
    atlas = 'suikablind',
    boss = { min = 4 },
    boss_colour = HEX("d96b58"),
    discovered = true,
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.after then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.GAME.blind:wiggle()
                    for i=1,#SuikaLatro.balls do 
                        local v = SuikaLatro.balls[i]
                        local perma_bonus_table = {}
                        if v.perma_bonuses then
                            for k,v in pairs(v.perma_bonuses) do
                                perma_bonus_table[k] = v
                            end
                        end 
                        table.insert(SuikaLatro.balls, Ball(v.body:getX(), v.body:getY(), v, 0, nil, 'c_base', v.edition, v.seal, nil, perma_bonus_table, (v.debuff and true) or false))
                        v.remove = true
                    end
                    return true
                end,
            }))
        end
    end
}

SMODS.Blind {
    key = "pineapple",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 8 },
    atlas = 'suikablind',
    boss = { min = 2 },
    boss_colour = HEX("ecd643"),
    discovered = true,
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.suika_drop_card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    if G.hand.cards[1] then
                        G.GAME.blind:wiggle()
                        local selected_card = pseudorandom_element(G.hand.cards, 'suika_pineapple')
                        draw_card(G.hand, G.discard, 100, 'down', false, selected_card)
                        if #G.hand.cards == G.hand.config.card_limit or #G.hand.cards == G.hand.config.card_limit - 1 then
                            draw_card(G.deck,G.hand, 100,'up', true)
                        end

                    end
                    return true
                end
            }))
        end
    end
}

SMODS.Blind {
    key = "strawberry",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 9 },
    atlas = 'suikablind',
    boss = { min = 2 },
    boss_colour = HEX("eb4350"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.blind_disabled then
            G.GAME.suika_hide_box = nil
        end
        
        if blind.disabled then return end

        if context.setting_blind then
            G.GAME.suika_hide_box = true
        end

        if context.after then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                func = function()
                    blind:disable()
                    G.GAME.suika_hide_box = nil
                    return true
                end
            }))
        end
    end,
}

SMODS.Blind {
    key = "notwatermelon",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 10 },
    atlas = 'suikablind',
    boss = { min = 3 },
    boss_colour = HEX("91d153"),
    discovered = true,
    loc_vars = function(self)
        local numerator, denominator = SMODS.get_probability_vars(self, 1, 15, 'suika_notwatermelon')
        return { vars = { numerator, denominator } }
    end,
    collection_loc_vars = function(self)
        return { vars = { '1', '15' } }
    end,
    calculate = function(self, blind, context)
        if blind.disabled then return end

        if context.suika_drop_card
        and SMODS.pseudorandom_probability(blind, 'suika_notwatermelon', 1, 15) then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5*G.SETTINGS.GAMESPEED,
                func = function()
                    G.GAME.blind:wiggle()
                    G.FUNCS.suika_play()
                    return true
                end
            }))
        end
    end
}

SMODS.Blind {
    key = "final_suika",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 11 },
    boss = { showdown = true },
    atlas = 'suikablind',
    boss = { min = 2 },
    boss_colour = HEX("82b32f"),
    discovered = true,
    calculate = function(self, blind, context)
        if context.setting_blind then
            SuikaLatro.ball_sizefactor = 18
        end
    end,
    disable = function(self)
        SuikaLatro.ball_sizefactor = 12
    end,
    defeat = function(self)
        SuikaLatro.ball_sizefactor = 12
    end
}