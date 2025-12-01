SMODS.Consumable:take_ownership('aura',
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
)

SMODS.Consumable:take_ownership('trance',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Seal:take_ownership('Red',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Seal:take_ownership('Blue',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Seal:take_ownership('Gold',
    {
    in_pool = function(self, args) return false end,
    no_collection = true
    },
    true
)

SMODS.Seal:take_ownership('Purple',
    {
        calculate = function(self, card, context)
            if context.discard and context.other_card == card then
                for i = 1, 2 do
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
                        return { message = localize('k_plus_tarot'), colour = G.C.PURPLE }
                    end
                end
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