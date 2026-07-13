-- copy of local functions from main wowie!
local function t_x(x)
    return to_pixels(
        -- offset 0,0 to be relative to the center of the screen, then transform x from pixels to screen units
        to_game_units(SuikaLatro.screen_w/2) + SuikaLatro.world_T.x + x / SuikaLatro.world_width * SuikaLatro.world_T.w
    )
end

local function t_y(y)
    -- same as above
    return to_pixels(to_game_units(SuikaLatro.screen_h/2) + SuikaLatro.world_T.y + y / SuikaLatro.world_height * SuikaLatro.world_T.h)
end

function SuikaLatro.f.score_message_joker(args)
    local obj = args.obj --obj is where the message gets played
    local obj_type = args.obj_type or args.obj.area and 'card'
    local col = args.colour or nil
    local message = args.message or nil
    local sound = args.sound or nil
    local juice_card = args.juice_card or nil --juice card is the card that gets juiced
    
    if juice_card then
        juice_card:juice_up()
    end

    if args.mult and args.mult > 0 then
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + args.mult
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
        col = col or G.C.MULT
        message = message or localize{type='variable',key='a_mult'..(args.mult<0 and '_minus' or ''),vars={math.abs(args.mult)}}
        sound = sound or 'multhit1'
    end
    if args.x_mult and args.x_mult > 0 then
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult * args.x_mult
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
        col = col or G.C.MULT
        message = message or localize{type='variable',key='a_xmult'..(args.x_mult<0 and '_minus' or ''),vars={math.abs(args.x_mult)}}
        sound = sound or 'multhit2'
    end
    if args.chips and args.chips > 0 then
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + args.chips
        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
        col = col or G.C.CHIPS
        message = message or localize{type='variable',key='a_chips'..(args.chips<0 and '_minus' or ''),vars={math.abs(args.chips)}}
        sound = sound or 'chips1'
    end
    if args.x_chips and args.x_chips > 0 then
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips * args.x_chips
        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
        col = col or G.C.CHIPS
        message = message or localize{type='variable',key='a_xchips'..(args.x_chips<0 and '_minus' or ''),vars={math.abs(args.x_chips)}}
        sound = sound or 'xchips'
    end
    if args.dollars and args.dollars ~= 0 then
        ease_dollars(args.dollars, true)
        col = args.dollars <-0.01 and G.C.RED or G.C.MONEY
        message = (args.dollars <-0.01 and '-' or '')..localize("$")..tostring(math.abs(args.dollars))
        sound = sound or 'coin3'
    end
    if args.retriggers and args.retriggers > 0 then
        message = localize('k_again_ex')
    end

    sound = sound or 'generic1'
    col = col or G.C.ORANGE
    message = message or ''

    local x_ = 0
    local y_ = 0

    if args.obj.pos then
        x_ = args.obj.pos.x
        y_ = args.obj.pos.y
    end

    attention_text({
        text = message,
        scale = args.obj_type == 'card' and 0.7 or 0.5,
        hold = 1,
        major = obj_type == 'card' and args.obj or G.ROOM_ATTACH,
        backdrop_colour = col,
        align = 'cm',
        offset = obj_type == 'card' and {x = -0.5/2 + 0.5*math.random(), y = 0.6*args.obj.T.h - 0.5/2 + 0.5*math.random()}
            or {x = -20/2 + 20/SuikaLatro.screen_w * (t_x(x_) + 20*math.random() - 0.5), y = -11.5/2 + 11.5/SuikaLatro.screen_h * (t_y(y_) + 20*math.random() - 0.5)},
        silent = true
    })
    
    play_sound(sound)
    
end

SMODS.Atlas {
    key = "suika_jokers",
    path = "suika_jokers.png",
    px = 71,
    py = 95
}

SMODS.Joker:take_ownership('greedy_joker',
    {
        config = { extra = { s_mult = 3, suit = 'Diamonds' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular') } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, card.ability.extra.suit) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.s_mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('lusty_joker',
    {
        config = { extra = { s_mult = 3, suit = 'Hearts' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular') } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, card.ability.extra.suit) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.s_mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('wrathful_joker',
    {
        config = { extra = { s_mult = 3, suit = 'Spades' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular') } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, card.ability.extra.suit) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.s_mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('gluttenous_joker',
    {
        config = { extra = { s_mult = 3, suit = 'Clubs' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular') } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, card.ability.extra.suit) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.s_mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('jolly',
    {
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
        config = { extra = { t_mult = 12, type = 'suika_five_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_ten_flush'] or SuikaLatro.triggered_combos['suika_mega_flush']) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('droll',
    {
        atlas = "suika_jokers",
        config = { extra = { t_mult = 20, type = 'suika_ten_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_mult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_mega_flush']) then
                return {
                    mult = card.ability.extra.t_mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('sly',
    {
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
        config = { extra = { t_chips = 100, type = 'suika_five_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_ten_flush'] or SuikaLatro.triggered_combos['suika_mega_flush']) then
                return {
                    chips = card.ability.extra.t_chips
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('crafty',
    {
        atlas = "suika_jokers",
        config = { extra = { t_chips = 180, type = 'suika_ten_flush' }, },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.t_chips, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_mega_flush']) then
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

--[[SMODS.Joker:take_ownership('four_fingers',
    {
        rarity = 3,
    }, true
)]]

SMODS.Joker:take_ownership('8_ball',
    {
        config = { extra = { odds = 2 } },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, '8_ball')
            return { vars = { numerator, denominator } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_rank(context.other_ball, 8) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
            and SMODS.pseudorandom_probability(card, '8_ball', 1, card.ability.extra.odds) then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                SuikaLatro.f.score_message_joker({
                    message = localize('k_plus_tarot'),
                    colour = G.C.PURPLE,
                    obj = card,
                    juice_card = card,
                })
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Tarot',
                            key_append = '8_ball'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
            end
        end
    }, true
)



SMODS.Joker:take_ownership('raised_fist',
    {
        cost = 4,
        calculate = function(self, card, context)
            if context.suika_before_jokers then
                local temp_Mult, temp_ID = 15, 15
                local raised_card = nil
                for k,v in ipairs(SuikaLatro.balls) do
                    if v.id < temp_ID and v.enhancement ~= 'm_stone' then
                        temp_Mult = get_size(v.id)/SuikaLatro.ball_sizefactor
                        temp_ID = v.id
                        raised_card = v
                    end
                end
                if raised_card then
                    SuikaLatro.f.score_message_joker({
                        mult = 3 * temp_Mult,
                        obj = raised_card,
                        juice_card = card,
                    })
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('fibonacci',
    {
        config = { extra = { mult = 8 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual then
                if SuikaLatro.f.is_rank(context.other_ball, 2) or
                SuikaLatro.f.is_rank(context.other_ball, 3) or
                SuikaLatro.f.is_rank(context.other_ball, 5) or
                SuikaLatro.f.is_rank(context.other_ball, 8) or
                SuikaLatro.f.is_rank(context.other_ball, 14) then
                    SuikaLatro.f.score_message_joker({
                        mult = card.ability.extra.mult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('scary_face',
    {
        rarity = 2,
        config = { extra = { chips = 100 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) then
                SuikaLatro.f.score_message_joker({
                    chips = card.ability.extra.chips,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)



SMODS.Joker:take_ownership('even_steven',
    {
        config = { extra = { mult = 4 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual then
                if SuikaLatro.f.is_rank(context.other_ball, 2) or
                SuikaLatro.f.is_rank(context.other_ball, 4) or
                SuikaLatro.f.is_rank(context.other_ball, 6) or
                SuikaLatro.f.is_rank(context.other_ball, 8) or
                SuikaLatro.f.is_rank(context.other_ball, 10) then
                    SuikaLatro.f.score_message_joker({
                        mult = card.ability.extra.mult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('odd_todd',
    {
        config = { extra = { chips = 31 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual then
                if SuikaLatro.f.is_rank(context.other_ball, 3) or
                SuikaLatro.f.is_rank(context.other_ball, 5) or
                SuikaLatro.f.is_rank(context.other_ball, 7) or
                SuikaLatro.f.is_rank(context.other_ball, 9) or
                SuikaLatro.f.is_rank(context.other_ball, 14) then
                    SuikaLatro.f.score_message_joker({
                        chips = card.ability.extra.chips,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('scholar',
    {
        rarity = 3,
        config = { extra = { x_mult = 3 } },
        in_pool = function(self, args)
            if G.playing_cards then
                for k,v in ipairs(G.playing_cards) do
                    if v.base.id == 14 then
                        return true
                    end
                end
            end
            return false
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.x_mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual then
                if SuikaLatro.f.is_rank(context.other_ball, 14) then
                    SuikaLatro.f.score_message_joker({
                        x_mult = card.ability.extra.x_mult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('business',
    {
        rarity = 2,
        config = { extra = { odds = 2, dollars = 10 } },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'business')
            return { vars = { numerator, denominator, card.ability.extra.dollars } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) and
                SMODS.pseudorandom_probability(card, 'business', 1, card.ability.extra.odds) then
                SuikaLatro.f.score_message_joker({
                    dollars = card.ability.extra.dollars,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('supernova',
    {
        rarity = 2,
        cost = 6,
        config = { extra = { mult_gain = 1, mult = 0 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_before_jokers and not context.blueprint then
                local poker_combo_count = 0
                for k,v in pairs(SuikaLatro.triggered_combos) do
                    poker_combo_count = poker_combo_count + 1
                end
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * poker_combo_count
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain * poker_combo_count } },
                    colour = G.C.RED,
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('superposition',
    {
        rarity = 2,
        cost = 6,
        in_pool = function(self, args)
            if G.playing_cards then
                for k,v in ipairs(G.playing_cards) do
                    if v.base.id == 14 then
                        return true
                    end
                end
            end
            return false
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_rank(context.other_ball, 14) and
            #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                SuikaLatro.f.score_message_joker({
                    message = localize('k_plus_spectral'),
                    colour = G.C.SET.Spectral,
                    obj = card,
                    juice_card = card,
                })
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        SMODS.add_card {
                            set = 'Spectral',
                            key_append = 'superposition'
                        }
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
            end
        end
    }, true
)

SMODS.Joker:take_ownership('ride_the_bus',
    {
        config = { extra = { mult_gain = 1, mult = 0 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_before_jokers and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            end
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) 
            and card.ability.extra.mult > 0 then
                card.ability.extra.mult = -card.ability.extra.mult_gain
                SuikaLatro.f.score_message_joker({
                    message = localize('k_reset'),
                    obj = card,
                    colour = G.C.RED,
                })
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('space',
    {
        in_pool = function(self, args) return false end,
        --no_collection = true
    }, true
)

SMODS.Joker:take_ownership('runner',
    {
        atlas = "suika_jokers",
        config = { extra = { chips = 0, chip_mod = 25 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
        end,
        calculate = function(self, card, context)
            if context.suika_before_jokers and not context.blueprint then
                if SuikaLatro.triggered_combos['suika_merge_4'] then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                    }
                end
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
        
    }, true
)

SMODS.Joker:take_ownership('dna',
    {
        config = { extra = { copy = 1, active = true } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.copy } }
        end,
        calculate = function(self, card, context)
            if context.first_hand_drawn and not context.blueprint then
                card.ability.extra.active = true
                local eval = function() return G.GAME.current_round.hands_played == 0 and #SuikaLatro.balls == 0 and not G.RESET_JIGGLES end
                juice_card_until(card, eval, true)
            end
            if context.suika_drop_card and card.ability.extra.active then
                card.ability.extra.active = false
                local card_copied = copy_card(context.other_card, nil, nil, G.playing_card)
                card_copied:add_to_deck()
                G.deck.config.card_limit = G.deck.config.card_limit + 1
                table.insert(G.playing_cards, card_copied)
                G.hand:emplace(card_copied)
                card_copied.states.visible = nil

                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_copied:start_materialize()
                        return true
                    end
                }))
                return {
                    message = localize('k_copied_ex'),
                    colour = G.C.CHIPS,
                    func = function() -- This is for timing purposes, it runs after the message
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                                return true
                            end
                        }))
                    end
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('splash',
    {
        in_pool = function(self, args) return false end,
        --no_collection = true
    }, true
)

SMODS.Joker:take_ownership('sixth_sense',
    {
        calculate = function(self, card, context)
            if context.suika_drop_card and not context.blueprint then
                if context.other_card:get_id() == 6 and G.GAME.current_round.hands_played == 0 and #SuikaLatro.balls == 1 then
                    context.other_card:start_dissolve()
                    context.other_card.being_destroyed = true
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                        G.E_MANAGER:add_event(Event({
                            func = (function()
                                SMODS.add_card {
                                    set = 'Spectral',
                                    key_append = 'sixth_sense'
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end)
                        }))
                        
                        return {
                            message = localize('k_plus_spectral'),
                            colour = G.C.SECONDARY_SET.Spectral,
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                    func = function()
                                        SMODS.destroy_cards(context.other_card)
                                        return true
                                    end
                                }))
                            end
                        }
                    end
                    --SMODS.destroy_cards(context.other_card)

                    return {
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.destroy_cards(context.other_card)
                                    return true
                                end
                            }))
                        end,
                    }
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('hiker',
    {
        config = { extra = { chips = 5 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips } }
        end,
        calculate = function(self, card, context)
            if context.suika_drop_card then
                context.other_card.ability.perma_bonus = (context.other_card.ability.perma_bonus or 0) +
                    card.ability.extra.chips
            end
        end
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
           if context.suika_before and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.hand_add
                return {
                    message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.hand_add } }
                }
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('todo_list',
    {
        config = { extra = { earning_list = {
            suika_five_flush = 2,
            suika_ten_flush = 5,
            suika_mega_flush = 8,
            suika_merge_1 = 1,
            suika_merge_2 = 1,
            suika_merge_3 = 2,
            suika_merge_4 = 2,
            suika_combo_breaker = 3,
            suika_lowball = 4,
        }, poker_hand = 'suika_lowball' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.earning_list[card.ability.extra.poker_hand], localize(card.ability.extra.poker_hand, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.suika_before_jokers and SuikaLatro.triggered_combos[card.ability.extra.poker_hand] then
                return {
                    dollars = card.ability.extra.earning_list[card.ability.extra.poker_hand] * SuikaLatro.triggered_combos[card.ability.extra.poker_hand],
                }
            end
            if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
                local _poker_hands = {}
                for handname, _ in pairs(G.GAME.hands) do
                    if string.find(handname, 'suika') and SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                        _poker_hands[#_poker_hands + 1] = handname
                    end
                end
                card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'to_do')
                return {
                    message = localize('k_reset')
                }
            end
        end,
        set_ability = function(self, card, initial, delay_sprites)
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if string.find(handname, 'suika') and SMODS.is_poker_hand_visible(handname) and handname ~= card.ability.extra.poker_hand then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            card.ability.extra.poker_hand = pseudorandom_element(_poker_hands, 'to_do')
        end
    }, true
)

SMODS.Joker:take_ownership('card_sharp',
    {
        in_pool = function(self, args) return false end,
        --no_collection = true
    }, true
)

SMODS.Joker:take_ownership('square',
    {
        config = { extra = { chips = 0, chip_mod = 4 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
        end,
        calculate = function(self, card, context)
            if context.press_play and not context.blueprint and #SuikaLatro.balls % 4 == 0 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS
                }
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
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
        config = { extra = { Xmult_gain = 0.1, Xmult = 1 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_drop_card and not context.blueprint then
                if next(SMODS.get_enhancements(context.other_card)) and not context.other_card.debuff and not context.other_card.vampired then
                    context.other_card.vampired = true
                    context.other_card:set_ability('c_base', nil, true)
                    card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                    return {
                        message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } },
                        colour = G.C.MULT,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    context.other_card.vampired = nil
                                    context.other_card:juice_up()
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('shortcut',
    {
        rarity = 3,
    }, true
)

SMODS.Joker:take_ownership('baron',
    {
        config = { extra = { xmult = 4 } },
        in_pool = function(self, args)
            if G.playing_cards then
                for k,v in ipairs(G.playing_cards) do
                    if v.base.id == 13 then
                        return true
                    end
                end
            end
            return false
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_hand_individual and SuikaLatro.f.is_rank(context.other_ball, 13) then
                if context.other_ball.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    SuikaLatro.f.score_message_joker({
                        x_mult = card.ability.extra.xmult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('cloud_9',
    {
        config = { extra = 4 },
    }, true
)

SMODS.Joker:take_ownership('obelisk',
    {
        in_pool = function(self, args) return false end,
        --no_collection = true
    }, true
)

SMODS.Joker:take_ownership('midas_mask',
    {
        calculate = function(self, card, context)
            if context.suika_drop_card and not context.blueprint then
                if context.other_card:is_face() and not context.other_card.debuff then
                    context.other_card:set_ability('m_gold', nil, true)
                    return {
                        message = localize('k_gold'),
                        colour = G.C.MONEY,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    context.other_card:juice_up()
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('photograph',
    {
        rarity = 2,
        config = { extra = { xmult = 2, ball_list = {} } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) then
                if #card.ability.extra.ball_list < 2 or card.ability.extra.ball_list[context.other_ball] then
                    card.ability.extra.ball_list[context.other_ball] = true
                    if not SuikaLatro.f.is_face(context.other_ball.merge_target) then
                        card.ability.extra.ball_list[context.other_ball.merge_target] = true
                    end
                    SuikaLatro.f.score_message_joker({
                        x_mult = card.ability.extra.xmult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
            if context.after and not context.blueprint then
                card.ability.extra.ball_list = {}
            end
        end
    }, true
)

SMODS.Joker:take_ownership('reserved_parking',
    {
        rarity = 2,
        config = { extra = { dollars = 3 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollars } }
        end,
        calculate = function(self, card, context)
            if context.suika_hand_individual then
                if SuikaLatro.f.is_face(context.other_ball) then
                    if not context.other_ball.debuff then
                        SuikaLatro.f.score_message_joker({
                            dollars = card.ability.extra.dollars,
                            obj = context.other_ball,
                            juice_card = card,
                        })
                    else
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    end
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('lucky_cat',
    {
        config = { extra = { Xmult_gain = 0.25, Xmult = 1 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_lucky
            return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_lucky_trigger and not context.blueprint then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                SuikaLatro.f.score_message_joker({
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    obj = card,
                    juice_card = card,
                })
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('trousers',
    {
        config = { extra = { mult_gain = 2, mult = 0 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult_gain, localize('suika_merge_2', 'poker_hands'), card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_before_jokers and not context.blueprint then
                local merge_2_count = SuikaLatro.triggered_combos['suika_merge_2'] or 0
                if merge_2_count > 0 then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain * merge_2_count
                    return {
                        message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult_gain * merge_2_count } },
                        colour = G.C.RED,
                    }
                end
            end
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    }, true
)

SMODS.Joker:take_ownership('ancient',
    {
        config = { extra = { xmult = 1.5 } },
        loc_vars = function(self, info_queue, card)
            local suit = (G.GAME.current_round.ancient_card or {}).suit or 'Spades'
            return { vars = { card.ability.extra.xmult, localize(suit, 'suits_singular'), colours = { G.C.SUITS[suit] } } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, G.GAME.current_round.ancient_card.suit) then
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.xmult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('walkie_talkie',
    {
        config = { extra = { chips = 20, mult = 4 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and
                (SuikaLatro.f.is_rank(context.other_ball, 4) or SuikaLatro.f.is_rank(context.other_ball, 10)) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
                SuikaLatro.f.score_message_joker({
                    chips = card.ability.extra.chips,
                    obj = context.other_ball,
                })
            end
        end
    }, true
)


SMODS.Joker:take_ownership('castle',
    {
        config = { extra = { chips = 0, chip_mod = 10 } },
    }, true
)

SMODS.Joker:take_ownership('smiley',
    {
        rarity = 3,
        cost = 7,
        config = { extra = { mult = 25 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('ticket',
    {
        config = { extra = { dollars = 4 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
            return { vars = { card.ability.extra.dollars } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and context.other_ball.enhancement == 'm_gold' then
                SuikaLatro.f.score_message_joker({
                    dollars = card.ability.extra.dollars,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('rough_gem',
    {
        config = { extra = { dollars = 1 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollars } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, "Diamonds") then
                SuikaLatro.f.score_message_joker({
                    dollars = card.ability.extra.dollars,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('bloodstone',
    {
        config = { extra = { odds = 2, Xmult = 1.5 } },
        loc_vars = function(self, info_queue, card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'bloodstone')
            return { vars = { numerator, denominator, card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, "Hearts") and
                SMODS.pseudorandom_probability(card, 'bloodstone', 1, card.ability.extra.odds) then
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.Xmult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('arrowhead',
    {
        config = { extra = { chips = 50 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, "Spades") then
                SuikaLatro.f.score_message_joker({
                    chips = card.ability.extra.chips,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('onyx_agate',
    {
        config = { extra = { mult = 7 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.mult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_suit(context.other_ball, "Clubs") then
                SuikaLatro.f.score_message_joker({
                    mult = card.ability.extra.mult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('glass',
    {
        config = { extra = { Xmult_gain = 0.5, Xmult = 1 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return { vars = { card.ability.extra.Xmult_gain, card.ability.extra.Xmult } }
        end,
        calculate = function(self, card, context)
            if context.balls_shattered then
                local glass_count = 0
                for i = 1, #context.other_balls do
                    if context.other_balls[i].enhancement == 'm_glass' then
                        glass_count = glass_count + 1
                    end
                end
                card.ability.extra.Xmult = card.ability.extra.Xmult + glass_count * card.ability.extra.Xmult_gain
                SuikaLatro.f.score_message_joker({
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult +
                                card.ability.extra.Xmult_gain * glass_count } },
                    colour = G.C.MULT,
                    obj = card,
                    juice_card = card,
                })
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end
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
        config = { extra = { chips = 0, chip_mod = 8 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chips, card.ability.extra.chip_mod } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual then
                if SuikaLatro.f.is_rank(context.other_ball, 2) then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    SuikaLatro.f.score_message_joker({
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        obj = card,
                        juice_card = card,
                    })
                end
            end
            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('idol',
    {
         config = { extra = { xmult = 2 } },
        loc_vars = function(self, info_queue, card)
            local idol_card = G.GAME.current_round.idol_card or { rank = 'Ace', suit = 'Spades' }
            return { vars = { card.ability.extra.xmult, localize(idol_card.rank, 'ranks'), localize(idol_card.suit, 'suits_plural'), colours = { G.C.SUITS[idol_card.suit] } } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and
                SuikaLatro.f.is_rank(context.other_ball, G.GAME.current_round.idol_card.id) and
                SuikaLatro.f.is_suit(context.other_ball, G.GAME.current_round.idol_card.suit) then
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.xmult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('seeing_double',
    {
        config = { extra = { xmult_low = 1.5, xmult_high = 2, is_high = false } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult_low, card.ability.extra.xmult_high } }
        end,
        calculate = function(self, card, context)
            if context.press_play and not context.blueprint then
                card.ability.extra.is_high = false
            end
            if context.suika_individual and SuikaLatro.f.is_rank(context.other_ball, 7) then
                if SuikaLatro.f.is_suit(context.other_ball, "Clubs") and card.ability.extra.is_high == false then
                    card.ability.extra.is_high = true
                    SuikaLatro.f.score_message_joker({
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        obj = card,
                    })
                end
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.is_high == false and card.ability.extra.xmult_low or card.ability.extra.xmult_high,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('matador',
    {
        cost = 6,
        config = { extra = { dollars = 1 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollars } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and G.GAME.current_round.hands_left == 0 and G.GAME.blind and G.GAME.blind.boss then
                SuikaLatro.f.score_message_joker({
                    dollars = card.ability.extra.dollars,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end
    }, true
)

SMODS.Joker:take_ownership('hit_the_road',
    {
        config = { extra = 1.5, x_mult = 1},
        in_pool = function(self, args)
            if G.playing_cards then
                for k,v in ipairs(G.playing_cards) do
                    if v.base.id == 11 then
                        return true
                    end
                end
            end
            return false
        end,
    }, true
)

SMODS.Joker:take_ownership('duo',
    {
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
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
        atlas = "suika_jokers",
        config = { extra = { Xmult = 3, type = 'suika_five_flush' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_ten_flush'] or SuikaLatro.triggered_combos['suika_mega_flush']) then
                return {
                    xmult = card.ability.extra.Xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('tribe',
    {
        atlas = "suika_jokers",
        config = { extra = { Xmult = 5, type = 'suika_ten_flush' } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.Xmult, localize(card.ability.extra.type, 'poker_hands') } }
        end,
        calculate = function(self, card, context)
            if context.joker_main and (SuikaLatro.triggered_combos[card.ability.extra.type] or SuikaLatro.triggered_combos['suika_mega_flush']) then
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
        rarity = 3,
        cost = 8,
        config = { extra = { xmult = 3 } },
        in_pool = function(self, args)
            if G.playing_cards then
                for k,v in ipairs(G.playing_cards) do
                    if v.base.id == 12 then
                        return true
                    end
                end
            end
            return false
        end,
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_rank(context.other_ball, 12) then
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.xmult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
            if context.suika_hand_individual and SuikaLatro.f.is_rank(context.other_ball, 12) then
                if context.other_ball.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED
                    }
                else
                    SuikaLatro.f.score_message_joker({
                        x_mult = card.ability.extra.xmult,
                        obj = context.other_ball,
                        juice_card = card,
                    })
                end
            end
        end,
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
        config = { extra = { xmult = 1, xmult_gain = 2 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.remove_playing_cards and not context.blueprint then
                local face_cards = 0
                for _, removed_card in ipairs(context.removed) do
                    if removed_card:is_face() then face_cards = face_cards + 1 end
                end
                if face_cards > 0 then
                    -- See note about SMODS Scaling Manipulation on the wiki
                    card.ability.extra.xmult = card.ability.extra.xmult + face_cards * card.ability.extra.xmult_gain
                    return { message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } } }
                end
            end
            if context.balls_shattered then
                local face_glass_count = 0
                for i = 1,#context.other_balls do
                    if context.other_balls[i].enhancement == 'm_glass' 
                    and SuikaLatro.f.is_face(context.other_balls[i]) then
                        face_glass_count = face_glass_count + 1
                    end
                end
                card.ability.extra.xmult = card.ability.extra.xmult + face_glass_count * card.ability.extra.xmult_gain
                SuikaLatro.f.score_message_joker({
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult +
                    card.ability.extra.xmult_gain * face_glass_count } },
                    colour = G.C.MULT,
                    obj = card,
                    juice_card = card,
                })
            end
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('triboulet',
    {
        config = { extra = { xmult = 3 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,
        calculate = function(self, card, context)
            if context.suika_individual and SuikaLatro.f.is_face(context.other_ball) then
                SuikaLatro.f.score_message_joker({
                    x_mult = card.ability.extra.xmult,
                    obj = context.other_ball,
                    juice_card = card,
                })
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('yorick',
    {
        config = {extra = {xmult = 1, discards = 12}}
    }, true
)

function SuikaLatro.f.return_retriggers(amt, source, ball)
    for i=1,amt do
        SuikaLatro.retrig[ball][#SuikaLatro.retrig[ball]+1] = source
    end
end

SMODS.Joker:take_ownership('mime',
    {
        calculate = function(self, card, context)
            if context.suika_ball_remain_repetition then
                SuikaLatro.f.return_retriggers(1, card, context.other_ball)
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('dusk',
    {
        calculate = function(self, card, context)
            if context.suika_ball_merge_repetition and G.GAME.current_round.hands_left == 0 then
                SuikaLatro.f.return_retriggers(1, card, context.other_ball)
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('hack',
    {
        calculate = function(self, card, context)
            if context.suika_ball_merge_repetition and 
            (SuikaLatro.f.is_rank(context.other_ball, 2) or 
            SuikaLatro.f.is_rank(context.other_ball, 3) or
            SuikaLatro.f.is_rank(context.other_ball, 4) or
            SuikaLatro.f.is_rank(context.other_ball, 5)) then
                SuikaLatro.f.return_retriggers(1, card, context.other_ball)
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('selzer',
    {
        config = { extra = { hands_left = 10 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.hands_left } }
        end,
        calculate = function(self, card, context)
            if context.suika_ball_merge_repetition then
                SuikaLatro.f.return_retriggers(1, card, context.other_ball)
            end
            if context.after and not context.blueprint then
                if card.ability.extra.hands_left - 1 <= 0 then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        message = localize('k_drank_ex'),
                        colour = G.C.FILTER
                    }
                else
                    card.ability.extra.hands_left = card.ability.extra.hands_left - 1
                    return {
                        message = card.ability.extra.hands_left .. '',
                        colour = G.C.FILTER
                    }
                end
            end
        end
    }, true
)

SMODS.Joker:take_ownership('sock_and_buskin',
    {
        name = 'Sock and Buskin 2',
        rarity = 3,
        config = { extra = { repetitions = 2 } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.repetitions } }
        end,
        calculate = function(self, card, context)
            if context.suika_ball_merge_repetition and SuikaLatro.f.is_face(context.other_ball) then
                SuikaLatro.f.return_retriggers(card.ability.extra.repetitions, card, context.other_ball)
            end
        end,
    }, true
)

SMODS.Joker:take_ownership('hanging_chad',
    {
        name = 'Hanging Chad 2',
        config = { extra = { repetitions = 2, ball_list = {} } },
        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.repetitions } }
        end,
        calculate = function(self, card, context)
            if context.suika_ball_merge_repetition and 
            (#card.ability.extra.ball_list < 2 or card.ability.extra.ball_list[context.other_ball]) then
                card.ability.extra.ball_list[context.other_ball] = true
                SuikaLatro.f.return_retriggers(card.ability.extra.repetitions, card, context.other_ball)
            end
            if context.after and not context.blueprint then
                card.ability.extra.ball_list = {}
            end
        end,
    }, true
)