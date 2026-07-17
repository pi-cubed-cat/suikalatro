SMODS.Blind:take_ownership('arm',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('ox',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('psychic',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)


SMODS.Blind:take_ownership('eye',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('mouth',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

--[[SMODS.Blind:take_ownership('club',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('goad',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('window',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('head',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Blind:take_ownership('final_leaf',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)]]

SMODS.Blind:take_ownership('pillar',
    {
    boss = { min = 2 },
    },
    true
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
    true
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
                G.GAME.blind:juice_up()
                play_sound('cancel', 1, 1)
                play_sound('highlight1', 1, 0.2)
            end
        end
    },
    true
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
    true
)

SMODS.Blind:take_ownership('flint',
    {
        name = "The Flint 2",
        calculate = function(self, blind, context)
            if blind.disabled then return end
        end
    },
    true
)

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
    true
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
    true
)

SMODS.Blind:take_ownership('mark',
    {
    boss = { min = 6 },
    },
    true
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
            table.insert(SuikaLatro.balls, Ball(pseudorandom('persimmon')*10, -400, {id = 5}))
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