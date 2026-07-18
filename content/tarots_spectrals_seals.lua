--[[SMODS.Consumable:take_ownership('aura',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Consumable:take_ownership('talisman',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Consumable:take_ownership('deja_vu',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)]]

--[[SMODS.Consumable:take_ownership('trance',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)]]

SMODS.Consumable:take_ownership('ouija', { -- Ouija
    config = { extra = { draw_cards = 4 }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.draw_cards } }
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        SMODS.draw_cards(card.ability.extra.draw_cards)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('tarot1')
                        used_tarot:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                for i = 1, #G.hand.cards do
                    local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('card1', percent)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                local _rank = pseudorandom_element(SMODS.Ranks, 'ouija')
                for i = 1, #G.hand.cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _card = G.hand.cards[i]
                            assert(SMODS.change_base(_card, nil, _rank.key))
                            return true
                        end
                    }))
                end
                for i = 1, #G.hand.cards do
                    local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                return true
            end
        }))
        delay(0.5)
    end,
}, true)

SMODS.Consumable:take_ownership('sigil', { -- Sigil
    config = { extra = { draw_cards = 6 }},
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.draw_cards } }
    end,
    use = function(self, card, area, copier)
        local used_tarot = copier or card
        SMODS.draw_cards(card.ability.extra.draw_cards)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        play_sound('tarot1')
                        used_tarot:juice_up(0.3, 0.5)
                        return true
                    end
                }))
                for i = 1, #G.hand.cards do
                    local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('card1', percent)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                local _suit = pseudorandom_element(SMODS.Suits, 'sigil')
                for i = 1, #G.hand.cards do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            local _card = G.hand.cards[i]
                            assert(SMODS.change_base(_card, _suit.key))
                            return true
                        end
                    }))
                end
                for i = 1, #G.hand.cards do
                    local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.15,
                        func = function()
                            G.hand.cards[i]:flip()
                            play_sound('tarot2', percent, 0.6)
                            G.hand.cards[i]:juice_up(0.3, 0.3)
                            return true
                        end
                    }))
                end
                return true
            end
        }))
        delay(0.5)
    end,
}, true)

SMODS.Seal:take_ownership('Red',
    {
        config = { extra = { retriggers = 1 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.retriggers } }
        end,
        calculate = function(self, card, context)

        end,
    },
    true
)

SMODS.Seal:take_ownership('Blue',
    {
        config = { extra = { upgrades = 3 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.upgrades } }
        end,
        calculate = function(self, card, context)

        end,
    },
    true
)

SMODS.Seal:take_ownership('Gold',
    {
        config = { extra = { money = 2 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { self.config.extra.money } }
        end,
    },
    true
)

SMODS.Seal:take_ownership('Purple',
    {
        calculate = function(self, card, context)
            if context.discard and context.other_card == card then
                --for i = 1, 2 do
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = function()
                                SMODS.add_card({ set = 'Tarot' })
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = localize('k_plus_tarot'), colour = G.C.PURPLE })
                    end
                --end
            end
        end
    },
    true
)

SMODS.Consumable:take_ownership('magician',
    {
    config = {mod_conv = 'm_lucky', max_highlighted = 3}
    },
    true
)

SMODS.Consumable:take_ownership('empress',
    {
    config = {mod_conv = 'm_mult', max_highlighted = 3}
    },
    true
)

SMODS.Consumable:take_ownership('heirophant',
    {
    config = {mod_conv = 'm_bonus', max_highlighted = 3}
    },
    true
)

SMODS.Consumable:take_ownership('lovers',
    {
    config = {mod_conv = 'm_wild', max_highlighted = 2}
    },
    true
)

local game_update_ref = Game.update
function Game:update(dt)
    game_update_ref(self, dt)
    if G.playing_cards then
        for _, v in ipairs(G.playing_cards) do
            if v.debuff then
                if SMODS.has_enhancement(v, 'm_wild') then
                    v.debuff = false
                end
            end
        end
    end
end

local debuff_card_ref = Blind.debuff_card
function Blind:debuff_card(card, from_blind)
    if not SMODS.has_enhancement(card, 'm_wild') then
        debuff_card_ref(self, card, from_blind)
    end
end

SMODS.Consumable:take_ownership('chariot',
    {
    config = {mod_conv = 'm_steel', max_highlighted = 2}
    },
    true
)

SMODS.Consumable:take_ownership('justice',
    {
    config = {mod_conv = 'm_glass', max_highlighted = 2}
    },
    true
)

SMODS.Consumable:take_ownership('devil',
    {
    config = {mod_conv = 'm_gold', max_highlighted = 2}
    },
    true
)

-- fix gold cards held in hand giving money
function Card:get_h_dollars()
    return 0
end

SMODS.Consumable:take_ownership('hanged_man',
    {
    config = {remove_card = true, max_highlighted = 3}
    },
    true
)

SMODS.Consumable:take_ownership('strength',
    {
    config = {mod_conv = 'up_rank', max_highlighted = 3}
    },
    true
)

SMODS.Consumable:take_ownership('tower',
    {
    config = {mod_conv = 'm_stone', max_highlighted = 2}
    },
    true
)