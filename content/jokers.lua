SMODS.Joker:take_ownership('greedy_joker',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('lusty_joker',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('wrathful_joker',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('gluttenous_joker',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('jolly',
    {
        config = { extra = { t_mult = 8, type = 'suika_merge_1' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('zany',
    {
        config = { extra = { t_mult = 12, type = 'suika_merge_2' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('mad',
    {
        config = { extra = { t_mult = 16, type = 'suika_merge_3' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('crazy',
    {
        config = { extra = { t_mult = 12, type = 'suika_five_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('droll',
    {
        config = { extra = { t_mult = 20, type = 'suika_ten_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('sly',
    {
        config = { extra = { t_chips = 50, type = 'suika_merge_1' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('wily',
    {
        config = { extra = { t_chips = 100, type = 'suika_merge_2' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('clever',
    {
        config = { extra = { t_chips = 150, type = 'suika_merge_3' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('devious',
    {
        config = { extra = { t_chips = 100, type = 'suika_five_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('crafty',
    {
        config = { extra = { t_chips = 180, type = 'suika_ten_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('half',
    {
        config = { extra = { mult = 20, size = -1 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                local is_under = true
                for k,v in ipairs(SuikaLatro.balls) do
                    if v.body:getY() + v.size < half_boundary.body:getY() then
                        is_under = false
                        break
                    end
                end
                if is_under then
                    return {
                        mult = card.ability.extra.mult
                    }
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('four_fingers',
    {
        rarity = 3,
    }, true
)

SMODS.Joker:take_ownership('mime',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('8_ball',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('dusk',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('raised_fist',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('fibonacci',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('scary_face',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('hack',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('even_steven',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('odd_todd',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('scholar',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('business',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('supernova',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('superposition',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('ride_the_bus',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('space',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('runner',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('dna',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('splash',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('sixth_sense',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('hiker',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('faceless',
    {
        rarity = 2,
        cost = 7,
        config = { extra = { dollars = 5, faces = 1 } },
    }, true
)

SMODS.Joker:take_ownership('green_joker',
    {
        config = { extra = { hand_add = 1, discard_sub = 1, mult = 0 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.hand_add, card.ability.extra.discard_sub, card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.discard and not context.blueprint and context.other_card == context.full_hand[#context.full_hand] then
                local prev_mult = card.ability.extra.mult
                card.ability.extra.mult = math.max(0, card.ability.extra.mult - card.ability.extra.discard_sub)
                if card.ability.extra.mult ~= prev_mult then
                    return {
                        message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.discard_sub } },
                        colour = G.C.RED
                    }
                end
            end
            if context.joker_main then
                if not context.blueprint then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.hand_add
                end
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('todo_list',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('card_sharp',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('square',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('seance',
    {
        config = { extra = { poker_hand = 'suika_mega_flush' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { localize(card.ability.extra.poker_hand, 'poker_hands') } }
        end,
        --[[calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.poker_hand] and
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'seance'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {
                    message = localize('k_plus_spectral'),
                    colour = G.C.SECONDARY_SET.Spectral
                }
            end
        end,]]
    }, true
)

SMODS.Joker:take_ownership('vampire',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('shortcut',
    {
        rarity = 3,
    }, true
)

SMODS.Joker:take_ownership('baron',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('obelisk',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('midas_mask',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('photograph',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('reserved_parking',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('lucky_cat',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('trousers',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('ancient',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('walkie_talkie',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('selzer',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('castle',
    {
        config = { extra = { chips = 0, chip_mod = 6 } },
    }, true
)

SMODS.Joker:take_ownership('selzer',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('smiley',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('ticket',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('selzer',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('sock_and_buskin',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('hanging_chad',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('rough_gem',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('bloodstone',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('arrowhead',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('onyx_agate',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('glass',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('flower_pot',
    {
        config = { extra = { Xmult = 3 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                if SuikaLatro.scoring_suits["Hearts"] > 0 and
                SuikaLatro.scoring_suits["Diamonds"] > 0 and
                SuikaLatro.scoring_suits["Spades"] > 0 and
                SuikaLatro.scoring_suits["Clubs"] > 0 then
                    return {
                        xmult = card.ability.extra.Xmult
                    }
                end
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('wee',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('idol',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('seeing_double',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('matador',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('hit_the_road',
    {
        config = { extra = 1.5, x_mult = 1},
        in_pool = function(self, args)
            for k,v in ipairs(G.playing_cards) do
                if v.base.id == 11 then
                    return true
                end
            end
            return false
        end,
    }, true
)

SMODS.Joker:take_ownership('duo',
    {
        config = { extra = { Xmult = 2, type = 'suika_merge_2' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('trio',
    {
        config = { extra = { Xmult = 3, type = 'suika_merge_3' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('family',
    {
        config = { extra = { Xmult = 4, type = 'suika_merge_4' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('order',
    {
        config = { extra = { Xmult = 3, type = 'suika_five_flush' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('tribe',
    {
        config = { extra = { Xmult = 5, type = 'suika_ten_flush' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and SuikaLatro.triggered_combos[card.ability.extra.type] then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('stuntman',
    {
        rarity = 2,
        config = { extra = { h_size = 1, chip_mod = 250 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chip_mod, card.ability.extra.h_size } }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    chips = card.ability.extra.chip_mod
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('shoot_the_moon',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('burnt',
    {
        rarity = 2,
        cost = 7,
        calculate = function(self, card, context)
            if context.pre_discard then
                local _poker_hands = {}
                for handname, _ in pairs(G.GAME.hands) do
                    if SMODS.is_poker_hand_visible(handname) then
                        _poker_hands[#_poker_hands + 1] = handname
                    end
                end
                local text = pseudorandom_element(_poker_hands, 'burnt')
                return {
                    level_up = true,
                    level_up_hand = text
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('caino',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('triboulet',
    {
        in_pool = function(self, args) return false end,
        no_collection = true
    }, true
)

SMODS.Joker:take_ownership('yorick',
    {
        config = {extra = {xmult = 1, discards = 12}}
    }, true
)