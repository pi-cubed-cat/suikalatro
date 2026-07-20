--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- PIXEL TO GAME UNITS TRANSFORM FUNCTIONS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

-- Transform pixels into game units (code from the Hot Potato mod's Plinko minigame) 
function to_game_units(val)
    return val / (G.TILESCALE*G.TILESIZE)
end

function to_pixels(val)
    return val * (G.TILESCALE*G.TILESIZE)
end

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

local function t_r(r)
    return to_pixels(r / SuikaLatro.world_height * SuikaLatro.world_T.h)
end

local function p_to_pixels(x, y)
    return t_x(x), t_y(y)
end

local function poly_to_pixels(x1, y1, x2, y2, x3, y3, x4, y4)
    return t_x(x1), t_y(y1), t_x(x2), t_y(y2), t_x(x3), t_y(y3), t_x(x4), t_y(y4)
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- SCORING FUNCTIONS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.score(score_type, amt)
    if score_type == '+mult' then
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult + amt
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
    elseif score_type == 'xmult' then
        G.GAME.current_round.current_hand.mult = G.GAME.current_round.current_hand.mult * amt
        G.GAME.current_round.current_hand.mult_text = tostring(G.GAME.current_round.current_hand.mult)
    elseif score_type == '+chips' then
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips + amt
        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
    elseif score_type == 'xchips' then
        G.GAME.current_round.current_hand.chips = G.GAME.current_round.current_hand.chips * amt
        G.GAME.current_round.current_hand.chip_text = tostring(G.GAME.current_round.current_hand.chips)
    end
end

function SuikaLatro.f.ball_scoring_message(pos, text_config, sound_config, no_randomness)
    local do_randomness = no_randomness and 0 or 1
    if pos and text_config then
        attention_text({
            text = text_config.text,
            scale = text_config.scale or 0.5,
            hold = text_config.hold or 1,
            major = G.ROOM_ATTACH,
            backdrop_colour = text_config.colour,
            align = 'cm',
            offset = {
                x = -10 + 20/SuikaLatro.screen_w * (t_x(pos.x) + 20*math.random()*do_randomness - 0.5), 
                y = -5.75 + 11.5/SuikaLatro.screen_h * (t_y(pos.y) + 20*math.random()*do_randomness - 0.5)
            },
            silent = true
        })
    end
    if sound_config then
        play_sound(sound_config.sound_key, sound_config.per or 1, sound_config.vol or 1)
    end
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- BIGASS IF-ELSE FOR BALL MODIFIERS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.debuff_message(x_, y_)
    SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = localize('k_debuffed'), colour = G.C.RED}, {sound_key = 'cancel'})
    G.GAME.blind:juice_up()
    play_sound('highlight1', 1, 0.2)
end

function SuikaLatro.f.enhancement_message(x_, y_, mtype, amt)
    if mtype == 'm_mult' then
        if not amt then amt = 4 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.MULT}, {sound_key = 'multhit1'})
        SuikaLatro.f.score('+mult', amt)
    elseif mtype == 'm_bonus' then
        if not amt then amt = 30 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.CHIPS}, {sound_key = 'chips1'})
        SuikaLatro.f.score('+chips', amt)
    elseif mtype == 'm_glass' then
        if not amt then amt = 2 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "X"..amt, colour = G.C.MULT}, {sound_key = 'multhit2'})
        SuikaLatro.f.score('xmult', amt)
    elseif mtype == 'm_lucky' then
        if pseudorandom('suika_lucky_mult') < G.GAME.probabilities.normal / 5 then
            SMODS.calculate_context({suika_lucky_trigger = true})
            SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.MULT}, {sound_key = 'multhit1'})
            SuikaLatro.f.score('+mult', amt)
        end
        if pseudorandom('suika_lucky_money') < G.GAME.probabilities.normal / 15 then
            SMODS.calculate_context({suika_lucky_trigger = true})
            SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "$"..amt, colour = G.C.MONEY}, {sound_key = 'coin3'})
            ease_dollars(20, true)
        end
    elseif mtype == 'm_steel' then
        if not amt then amt = 1.5 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "X"..amt, colour = G.C.MULT}, {sound_key = 'multhit2'})
        SuikaLatro.f.score('xmult', amt)
    elseif mtype == 'm_gold' then
        if not amt then amt = 3 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "$"..amt, colour = G.C.MONEY}, {sound_key = 'coin3'})
        ease_dollars(amt, true)
    end
end

function SuikaLatro.f.edition_message(x_, y_, etype, amt)
    if etype == 'e_foil' then
        if not amt then amt = 50 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.DARK_EDITION}, {sound_key = 'foil2', per = 1, vol = 0.7})
        SuikaLatro.f.score('+chips', amt)
    elseif etype == 'e_holo' then
        if not amt then amt = 10 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.DARK_EDITION}, {sound_key = 'foil2', per = 1, vol = 0.7})
        SuikaLatro.f.score('+mult', amt)
    elseif mtype == 'e_polychrome' then
        if not amt then amt = 1.5 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "+"..amt, colour = G.C.DARK_EDITION}, {sound_key = 'foil2', per = 1, vol = 0.7})
        SuikaLatro.f.score('xmult', amt)
    end
end

function SuikaLatro.f.seal_message(x_, y_, stype, amt)
    if stype == "Gold" then
        if not amt then amt = 2 end
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = "$"..amt, colour = G.C.MONEY}, {sound_key = 'coin3'})
        play_sound('coin3')
        ease_dollars(amt, true)
    end
    if stype == "Blue" then
        if not amt then amt = 3 end
        local _poker_hands = {}
        for handname, _ in pairs(G.GAME.hands) do
            if string.find(handname, 'suika') and SMODS.is_poker_hand_visible(handname) then
                _poker_hands[#_poker_hands + 1] = handname
            end
        end
        local _hand = pseudorandom_element(_poker_hands, 'blue_seal')
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = localize('k_upgrade_ex'), colour = G.C.SECONDARY_SET.Planet}, {sound_key = 'generic1'})
        SMODS.upgrade_poker_hands({hands = {_hand}, level_up = amt})
    end
    if stype == "Red" then
        SuikaLatro.f.ball_scoring_message({x = x_, y = y_}, {text = localize('k_again_ex'), colour = G.C.RED}, {sound_key = 'generic1'})
    end
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- INDIVIDUAL BALL MERGE SCORING (and Merge-# poker combos)
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.eval_merge_ball_scoring_effects(merge_count, ball1, ball2, is_retrigger, score_ball1, score_ball2)
    local x_pos = ball1.x
    local y_pos = ball1.y
    local id_ = ball1.enhancement == 'm_stone' and 2 or ball1.id
    local id2_ = ball2.enhancement == 'm_stone' and 2 or ball2.id
    
    local self_debuff = ball1.debuff
    local other_debuff = ball2.debuff
    local self_enhancement = not self_debuff and ball1.enhancement or nil
    local self_edition = not self_debuff and ball1.edition or nil
    local self_seal = not self_debuff and ball1.seal or nil
    local other_enhancement = not other_debuff and ball2.enhancement or nil
    local other_edition = not other_debuff and ball2.edition or nil
    local other_seal = not other_debuff and ball2.seal or nil

    if not is_retrigger then
        
        local poker_combo = nil
        if merge_count >= 1 and merge_count <= 4 then
            poker_combo = 'suika_merge_'..merge_count
        elseif merge_count >= 5 then
            poker_combo = 'suika_combo_breaker'
        end

        
        G.E_MANAGER:add_event(Event({ -- base chips & combo #
            trigger = 'immediate',
            blockable = false,
            func = function()
                SuikaLatro.f.ball_scoring_message({x = x_pos, y = y_pos}, {
                    text = tostring(merge_count.."X"), colour = merge_count < 5 and G.C.ORANGE or G.C.RED,
                    scale = 0.5 + merge_count/10, hold = 0.3
                }, {
                    sound_key = 'multhit1', per = math.random()*0.2 + 0.7 + 0.1*merge_count, vol = 0.6 + merge_count/20
                }, true)
                SuikaLatro.f.score_poker_combo(poker_combo)

                local current_hand_chips = (self_debuff and 0 or SuikaLatro.f.get_base_chips(id_))
                + (other_debuff and 0 or SuikaLatro.f.get_base_chips(id2_))
                + (self_debuff and 0 or (ball1.perma_bonuses['perma_bonus'] or 0))
                + (other_debuff and 0 or (ball2.perma_bonuses['perma_bonus'] or 0))
                SuikaLatro.f.score('+chips', current_hand_chips)
                return true
            end
        }))
    else
        local amt = (self_debuff and 0 or SuikaLatro.f.get_base_chips(id_))
        + (other_debuff and 0 or SuikaLatro.f.get_base_chips(id2_))
        + (self_debuff and 0 or (ball1.perma_bonuses['perma_bonus'] or 0))
        + (other_debuff and 0 or (ball2.perma_bonuses['perma_bonus'] or 0))
        SuikaLatro.f.enhancement_message(x_pos, y_pos, 'm_chips', amt) -- chips of balls
    end
    
    delay(0.1)

    if score_ball1 or not is_retrigger then
        if not self_debuff then
            if self_enhancement ~= 'c_base' and self_enhancement ~= 'm_gold' and self_enhancement ~= 'm_steel' then -- enhancements for ball 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1,
                    func = function()
                        SuikaLatro.f.enhancement_message(x_pos, y_pos, self_enhancement)
                        return true
                    end
                }))
            end
            if self_edition and self_edition ~= 'e_negative' then -- editions for ball 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1,
                    func = function()
                        SuikaLatro.f.edition_message(x_pos, y_pos, self_edition)
                        return true
                    end
                }))
            end
        end
    end

    if score_ball2 or not is_retrigger then
        if not other_debuff then
            if other_enhancement ~= 'c_base' and other_enhancement ~= 'm_gold' and other_enhancement ~= 'm_steel' then -- enhancements for ball 2
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1 + (self_enhancement ~= 'c_base' and 1 or 0),
                    func = function()
                        SuikaLatro.f.enhancement_message(x_pos, y_pos, other_enhancement)
                        return true
                    end
                }))
            end
            if other_edition and other_edition ~= 'e_negative' then -- editions for ball 2
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1 + (self_edition and 1 or 0),
                    func = function()
                        SuikaLatro.f.edition_message(x_pos, y_pos, other_edition)
                        return true
                    end
                }))
            end 
        end
    end

    if score_ball1 or not is_retrigger then
        if not self_debuff then
            if self_seal and self_seal == 'Gold' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1,
                    func = function()
                        SuikaLatro.f.seal_message(x_pos, y_pos, self_seal)
                        return true
                    end
                }))
            end
        end
    end
    if score_ball2 or not is_retrigger then
        if not other_debuff then
            if other_seal and other_seal == 'Gold' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 1 + (self_seal == "Gold" and 1 or 0),
                    func = function()
                        SuikaLatro.f.seal_message(x_pos, y_pos, other_seal)
                        return true
                    end
                }))
            end
        end
    end
    if not is_retrigger then
        if self_debuff or other_debuff then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay = 1,
                func = function()
                    SuikaLatro.f.debuff_message(x_pos, y_pos)
                    return true
                end
            }))
        end
        if self_debuff and other_debuff then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                blockable = false,
                delay = 2,
                func = function()
                    SuikaLatro.f.debuff_message(x_pos, y_pos)
                    return true
                end
            }))
        end
    end
    local scoring_list = {{ball = ball1, is_score = score_ball1}, {ball = ball2, is_score = score_ball2}}
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        blockable = false,
        func = function()
            for i=1,2 do
                scoring_list[i].ball.pos = {
                    x = x_pos,
                    y = y_pos,
                }
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    blockable = false,
                    --delay = 0.25*(-1 + i),
                    func = function()
                        if not scoring_list[i].ball.debuff and (not is_retrigger or scoring_list[i].is_score) then
                            SMODS.calculate_context({suika_individual = true, other_ball = scoring_list[i].ball})
                        else
                            
                        end
                    return true
                    end
                }))
                delay(0.25)
            end
            return true
        end
    }))
    
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- AFTER MERGING EFFECTS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.balls_after_merging()
    for k,v in ipairs(SuikaLatro.balls) do
        local x_pos, y_pos = v.body:getX(), v.body:getY()
        v.pos = {
            x = x_pos,
            y = y_pos,
        }
        
        SuikaLatro.retrig[v] = {'base'}
        if v.seal and v.seal == 'Red' then
            SuikaLatro.retrig[v][#SuikaLatro.retrig[v]+1] = 'Red'
        end
        SMODS.calculate_context({suika_ball_remain_repetition = true, other_ball = v})
        
        if v.debuff then SuikaLatro.retrig[v] = {'base'} end

        for i = 1, #SuikaLatro.retrig[v] do
            if SuikaLatro.retrig[v][i] == "Red" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.seal_message(v.pos.x, v.pos.y, "Red")
                        return true
                    end
                }))
            elseif type(SuikaLatro.retrig[v][i]) == 'table' then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.score_message_joker({
                            retriggers = 1,
                            obj = v,
                            juice_card = SuikaLatro.retrig[v][i],
                        })
                        return true
                    end
                }))
            end
            if v.enhancement == 'm_steel' and not v.debuff then
                delay(1)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.enhancement_message(v.pos.x, v.pos.y, v.enhancement)
                    return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.calculate_context({suika_hand_individual = true, other_ball = v})
                    return true
                end
            }))
            
        end
    end
end

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
-- END OF ROUND EFFECTS
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--

function SuikaLatro.f.balls_end_of_round()
    for k,v in ipairs(SuikaLatro.balls) do
        local x_pos, y_pos = v.body:getX(), v.body:getY()
        v.pos = {
            x = x_pos,
            y = y_pos,
        }
        
        SuikaLatro.retrig[v] = {'base'}
        if v.seal and v.seal == 'Red' then
            SuikaLatro.retrig[v][#SuikaLatro.retrig[v]+1] = 'Red'
        end
        SMODS.calculate_context({suika_ball_remain_repetition = true, other_ball = v})

        if v.debuff then SuikaLatro.retrig[v] = {'base'} end

        for i = 1, #SuikaLatro.retrig[v] do
            if SuikaLatro.retrig[v][i] == "Red" then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.seal_message(v.pos.x, v.pos.y, "Red")
                        return true
                    end
                }))
            elseif type(SuikaLatro.retrig[v][i]) == 'table' then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.score_message_joker({
                            retriggers = 1,
                            obj = v,
                            juice_card = SuikaLatro.retrig[v][i],
                        })
                        return true
                    end
                }))
            end
            if v.enhancement == 'm_gold' and not v.debuff then
                delay(1)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.enhancement_message(v.pos.x, v.pos.y, v.enhancement)
                    return true
                    end
                }))
            end
            if v.seal and v.seal == 'Blue' and not v.debuff then
                delay(1)
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SuikaLatro.f.seal_message(v.pos.x, v.pos.y, v.seal)
                    return true
                    end
                }))
            end
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.calculate_context({suika_hand_individual_endofround = true, other_ball = v})
                    return true
                end
            }))
        end
    end
end

--[[function SuikaLatro.f.create_dummy_card(ball)
    local suit = ball.suit
    local id = ball.id
    local card_abbrev_suit = string.upper(string.sub(suit, 1, -#(suit)))
    local card_abbrev_rank = id..''
    if id >= 10 and id <= 14 then
        if id == 10 then card_abbrev_rank = 'T'
        elseif id == 11 then card_abbrev_rank = 'J'
        elseif id == 12 then card_abbrev_rank = 'Q'
        elseif id == 13 then card_abbrev_rank = 'K'
        elseif id == 14 then card_abbrev_rank = 'A'
        end
    end
    print(card_abbrev_suit..'_'..card_abbrev_rank)
    local dummy_card = create_playing_card({
        front = G.P_CARDS[card_abbrev_suit..'_'..card_abbrev_rank],
        center = G.P_CENTERS.c_base}, 
        G.hand, true, nil, {G.C.SECONDARY_SET.Enhanced}, true
    )
    if ball.enhancement ~= 'c_base' then
        dummy_card:set_ability(ball.enhancement, true)
    end
    if ball.edition then
        dummy_card:set_edition(ball.edition, true)
    end
    if ball.seal then
        dummy_card.seal = ball.seal
    end
    if ball.debuff then
        dummy_card.debuff = true
    end
    for kk,vv in pairs(ball.perma_bonuses) do
        dummy_card.ability[kk] = vv
    end
end]]