--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- PLAY HAND BUTTON
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

G.FUNCS.suika_can_play = function(e)
    if SuikaLatro.balls and #SuikaLatro.balls > 0 
    and (G.SETTINGS.suikalatro_tutorial_complete 
    or G.SETTINGS.suikalatro_tutorial_progress.completed_parts['drop5']) then 
        e.config.colour = G.C.BLUE
        e.config.button = 'suika_play'
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- PLAY HAND (before merging)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

G.FUNCS.suika_play = function(e)
    if G.play and G.play.cards[1] then print("word") return end
    --check the hand first

    stop_use()
    G.hand:unhighlight_all()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    SuikaLatro.triggered_combos = {}
    SuikaLatro.scoring_suits = {
        ['Hearts'] = 0,
        ['Diamonds'] = 0,
        ['Spades'] = 0,
        ['Clubs'] = 0
    }
    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    delay(0.4)

    SuikaLatro.do_physics = false
    SuikaLatro.retrig = {}

    if G.GAME.blind:press_play() then
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                SMODS.juice_up_blind()
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))
        delay(0.4)
    end

    SuikaLatro.lowball = true

    -- evaluate flushes
    local has_ff = #SMODS.find_card('j_four_fingers') or 0
    for k,v in pairs(SuikaLatro.flush_groups) do
        local x_ = v[1].body:getX()
        local y_ = v[1].body:getY()
        if #v >= 5 - has_ff and #v < 10 - has_ff then
            delay(1)
            G.E_MANAGER:add_event(Event({
                func = function()
                    SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {
                        text = "5-Flush!", colour = G.C.SUITS[v[1].suit],
                        scale = 0.8, hold = 0.3
                    }, {
                        sound_key = 'chips1', per = math.random()*0.2 + 0.9, vol = 1
                    }, true)
                    SuikaLatro.f.score_poker_combo('suika_five_flush')
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        elseif #v >= 10 - has_ff and #v < 15 - has_ff then
            delay(1)
            G.E_MANAGER:add_event(Event({
                func = function()
                    SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {
                        text = "10-Flush!", colour = G.C.SUITS[v[1].suit],
                        scale = 1, hold = 0.3
                    }, {
                        sound_key = 'chips1', per = math.random()*0.2 + 0.9, vol = 1
                    }, true)
                    SuikaLatro.f.score_poker_combo('suika_ten_flush')
                    SuikaLatro.f.score_poker_combo('suika_five_flush', true)
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        elseif #v >= 15 - has_ff then
            delay(1)
            G.E_MANAGER:add_event(Event({
                func = function()
                    SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {
                        text = "Mega Flush!", colour = G.C.SUITS[v[1].suit],
                        scale = 1.2, hold = 0.3
                    }, { 
                        sound_key = 'chips1', per = math.random()*0.2 + 0.9, vol = 1
                    }, true)
                    SuikaLatro.f.score_poker_combo('suika_mega_flush')
                    SuikaLatro.f.score_poker_combo('suika_ten_flush', true)
                    SuikaLatro.f.score_poker_combo('suika_five_flush', true)
                    for i=1,#v do
                        v[i].flush_size = 0
                    end
                    return true
                end
            }))
        end

    end
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.show_flushes = false
            for k,v in pairs(SuikaLatro.flush_groups) do
                for i=1,#v do
                    v[i].flush_size = 0
                end
            end
        return true
        end
    }))
    delay(3)
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.do_physics = true
            SuikaLatro.do_merging = true
        return true
        end
    }))
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- PLAY HAND (after merging)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

G.FUNCS.suika_play_pt2 = function(e)
    SuikaLatro.do_merging = false
    for k,v in ipairs(SuikaLatro.balls) do
        v.merges = 0
    end
    if SuikaLatro.lowball == true then
        SuikaLatro.f.ball_scoring_message(nil, nil, { 
            sound_key = 'chips1', per = math.random()*0.2 + 0.9, vol = 1
        }, true)
        SuikaLatro.f.score_poker_combo('suika_lowball')
    end
    G.E_MANAGER:add_event(Event({
        func = function()
            for k,v in ipairs(SuikaLatro.balls) do
                local x_pos, y_pos = v.body:getX(), v.body:getY()
                v.pos = {
                    x = x_pos,
                    y = y_pos,
                }
            end
            SMODS.calculate_context({suika_before_jokers = true})
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        func = function()
            SuikaLatro.f.balls_after_merging()
            return true
        end
    }))
    delay(2)
    G.E_MANAGER:add_event(Event({
        func = function()
            --G.GAME.current_round.current_hand.chip_total = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            --G.GAME.current_round.current_hand.chip_total_text = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
            return true
        end
    }))
    delay(1)
    G.E_MANAGER:add_event(Event({
        func = function()
            --play_sound('chips2')
            --G.GAME.chips = G.GAME.chips + G.GAME.current_round.current_hand.chip_total
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    SuikaLatro.retrig = {}
                    update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
                    SuikaLatro.f.evaluate_play_jokers()
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.GAME.hands_played = G.GAME.hands_played + 1
                    G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    SuikaLatro.show_flushes = true
                    return true
                end
            }))
            return true
        end)
    }))

end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- EVALUATE JOKERS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

SuikaLatro.f.evaluate_play_jokers = function(e)
    percent = 0.3
    percent_delta = 0.08

    if not G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text) then
    
            mult = mod_mult(G.GAME.current_round.current_hand.mult)
            hand_chips = mod_chips(G.GAME.current_round.current_hand.chips)
            
            SMODS.calculate_context({suika_before = true})

            local modded = false
    
            mult, hand_chips, modded = G.GAME.blind:modify_hand(G.play.cards, poker_hands, text, mult, hand_chips, scoring_hand)
            mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
            if modded then update_hand_text({sound = 'chips2', modded = modded}, {chips = hand_chips, mult = mult}) end
            delay(0.3)

        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        percent = percent + percent_delta
        for _, area in ipairs(SMODS.get_card_areas('jokers')) do for _, _card in ipairs(area.cards) do
            local effects = {}
            -- remove base game joker edition calc
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, pre_joker = true})
            if eval.edition then effects[#effects+1] = eval end
            

            -- Calculate context.joker_main
            local joker_eval, post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})
            if next(joker_eval) then
                if joker_eval.edition then joker_eval.edition = {} end
                table.insert(effects, joker_eval)
                for _, v in ipairs(post) do effects[#effects+1] = v end
                if joker_eval.retriggers then
                    for rt = 1, #joker_eval.retriggers do
                        local rt_eval, rt_post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                        if next(rt_eval) then
                            table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                            table.insert(effects, rt_eval)
                            for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                        end
                    end
                end
            end

            -- Calculate context.other_joker effects
            for _, _area in ipairs(SMODS.get_card_areas('jokers')) do
                for _, _joker in ipairs(_area.cards) do
                    local other_key = 'other_unknown'
                    if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                    if _card.ability.consumeable then other_key = 'other_consumeable' end
                    if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                    -- TARGET: add context.other_something identifier to your cards
                    local joker_eval,post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                    if next(joker_eval) then
                        if joker_eval.edition then joker_eval.edition = {} end
                        joker_eval.jokers.juice_card = _joker
                        table.insert(effects, joker_eval)
                        for _, v in ipairs(post) do effects[#effects+1] = v end
                        if joker_eval.retriggers then
                            for rt = 1, #joker_eval.retriggers do
                                local rt_eval, rt_post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                                if next(rt_eval) then
                                    table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                                    table.insert(effects, rt_eval)
                                    for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                                end
                            end
                        end
                    end
                end
            end
            for _, _area in ipairs(SMODS.get_card_areas('individual')) do
                local other_key = 'other_unknown'
                if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                if _card.ability.consumeable then other_key = 'other_consumeable' end
                if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                -- TARGET: add context.other_something identifier to your cards
                local _eval,post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                if next(_eval) then
                    _eval.individual.juice_card = _area.scored_card
                    table.insert(effects, _eval)
                    for _, v in ipairs(post) do effects[#effects+1] = v end
                    if _eval.retriggers then
                        for rt = 1, #_eval.retriggers do
                            local rt_eval, rt_post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                            if next(rt_eval) then
                                table.insert(effects, {_eval.retriggers[rt]})
                                table.insert(effects, rt_eval)
                                for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                            end
                        end
                    end
                end
            end

            -- calculate edition multipliers
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, post_joker = true})
            if eval.edition then effects[#effects+1] = eval end

            SMODS.trigger_effects(effects, _card)
        end end

        -- context.final_scoring_step calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, final_scoring_step = true})
        
        -- TARGET: effects before deck final_scoring_step
        local nu_chip, nu_mult = G.GAME.selected_back:trigger_effect{context = 'final_scoring_step', chips = hand_chips, mult = mult}
        --mult = mod_mult(nu_mult or mult)
        --hand_chips = mod_chips(nu_chip or hand_chips)

        local cards_destroyed = {}
        for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'destroying_cards')) do
            SMODS.calculate_destroying_cards({ full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, cardarea = v }, cards_destroyed, v == G.play and scoring_hand or nil)
        end
        
        -- context.remove_playing_cards calculations
        if cards_destroyed[1] then
            SMODS.calculate_context({scoring_hand = scoring_hand, remove_playing_cards = true, removed = cards_destroyed})
        end
        
        -- TARGET: effects when cards are removed
        


        local glass_shattered = {}
        for k, v in ipairs(cards_destroyed) do
            if v.shattered then glass_shattered[#glass_shattered+1] = v end
        end

        check_for_unlock{type = 'shatter', shattered = glass_shattered}
        
        for i=1, #cards_destroyed do
            G.E_MANAGER:add_event(Event({
                func = function()
                    if cards_destroyed[i].shattered then
                        cards_destroyed[i]:shatter()
                    else
                        cards_destroyed[i]:start_dissolve()
                    end
                  return true
                end
              }))
        end
    else
        mult = mod_mult(0)
        hand_chips = mod_chips(0)
        SMODS.displayed_hand = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                if SMODS.hand_debuff_source then SMODS.hand_debuff_source:juice_up(0.3,0) else SMODS.juice_up_blind() end
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))

        play_area_status_text("Not Allowed!")--localize('k_not_allowed_ex'), true)
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Debuff Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        -- context.debuffed_hand calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})
        
        -- TARGET: effects after hand debuffed by blind
    end
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.current_round.current_hand.chip_total = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
                G.GAME.current_round.current_hand.chip_total_text = G.GAME.current_round.current_hand.mult * G.GAME.current_round.current_hand.chips
                return true
            end
        }))
        delay(1)
    
          for name, parameter in pairs(SMODS.Scoring_Parameters) do    
            update_hand_text({delay = 0}, {[name] = parameter.default_value })
          end

        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('chips2')
                check_and_set_high_score('hand',  G.GAME.current_round.current_hand.chip_total )
                G.GAME.chips = G.GAME.chips + G.GAME.current_round.current_hand.chip_total
                return true
            end
        }))
        delay(1)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.FUNCS.chip_UI_set()
                return true
            end
        }))
        G.E_MANAGER:add_event(Event({
          trigger = 'ease',
          blocking = true,
          ref_table = G.GAME.current_round.current_hand,
          ref_value = 'chip_total',
          ease_to = 0,
          delay =  0.5,
          func = (function(t) return math.floor(t) end)
        }))

    -- context.after calculations
    SMODS.calculate_context({scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
    
    -- TARGET: effects after hand evaluation

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()     
            if G.GAME.modifiers.debuff_played_cards then 
                for k, v in ipairs(scoring_hand) do v.ability.perma_debuff = true end
            end
        return true end)
      }))

  end